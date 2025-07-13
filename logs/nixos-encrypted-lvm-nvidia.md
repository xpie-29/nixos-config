
# 🐧 NixOS Encrypted LVM Installation on Multi-NVMe Setup (with NVIDIA + Wayland)

This guide documents the full process of installing NixOS with full-disk LUKS encryption over LVM, across two NVMe drives, using the proprietary NVIDIA drivers with Wayland support.

---

## 🧱 System Overview

- **Drives**:
  - `/dev/nvme1n1` – 4TB NVMe (boot + part of encrypted volume)
  - `/dev/nvme0n1` – 2TB NVMe (part of encrypted volume)
- **Encryption**: LUKS (same passphrase for both)
- **LVM Volume Group**: `nixvg0`
- **Logical Volumes**:
  - `root` – 200GB
  - `home` – Remainder of space
  - `swap` – 16GB (for 32GB RAM system)
- **Bootloader**: GRUB (for theme customization)
- **GPU**: Always-on proprietary NVIDIA with Wayland (Plasma 6)
- **Partition Labels**: Used for device references instead of UUIDs

---

## 🧼 Step 1: Wipe Drives

```bash
wipefs --all --force /dev/nvme0n1
wipefs --all --force /dev/nvme1n1
dd if=/dev/zero of=/dev/nvme0n1 bs=1M count=16 status=progress
dd if=/dev/zero of=/dev/nvme1n1 bs=1M count=16 status=progress
```

---

## 🧾 Step 2: Partition Drives

### 4TB Drive (`/dev/nvme1n1`)

```bash
parted /dev/nvme1n1 -- mklabel gpt
parted /dev/nvme1n1 -- mkpart primary 512MiB 100%
parted /dev/nvme1n1 -- mkpart ESP fat32 1MiB 512MiB
parted /dev/nvme1n1 -- set 2 esp on
parted /dev/nvme1n1 name 1 luks4tb
parted /dev/nvme1n1 name 2 ESP
```

### 2TB Drive (`/dev/nvme0n1`)

```bash
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart primary 0% 100%
parted /dev/nvme0n1 name 1 luks2tb
```

---

## 🔐 Step 3: Encrypt with LUKS

```bash
cryptsetup luksFormat /dev/nvme1n1p1
cryptsetup luksFormat /dev/nvme0n1p1
cryptsetup open /dev/nvme1n1p1 crypt0
cryptsetup open /dev/nvme0n1p1 crypt1
```

---

## 📦 Step 4: Set Up LVM

```bash
pvcreate /dev/mapper/crypt0 /dev/mapper/crypt1
vgcreate nixvg0 /dev/mapper/crypt0 /dev/mapper/crypt1
lvcreate -L 16G nixvg0 -n swap
lvcreate -L 200G nixvg0 -n root
lvcreate -l 100%FREE nixvg0 -n home
```

---

## 📁 Step 5: Format and Mount

```bash
mkfs.fat -F32 /dev/nvme1n1p2
mkfs.ext4 /dev/nixvg0/root
mkfs.ext4 /dev/nixvg0/home
mkswap /dev/nixvg0/swap

mount /dev/nixvg0/root /mnt
mkdir /mnt/boot /mnt/home
mount /dev/nixvg0/home /mnt/home
mount /dev/nvme1n1p2 /mnt/boot
swapon /dev/nixvg0/swap
```

---

## ⚙️ Step 6: Generate and Edit Configs

```bash
nixos-generate-config --root /mnt
```

### `hardware-configuration.nix`

```nix
boot.initrd.luks.devices = {
  crypt0 = {
    device = "/dev/disk/by-partlabel/luks4tb";
    preLVM = true;
  };
  crypt1 = {
    device = "/dev/disk/by-partlabel/luks2tb";
    preLVM = true;
  };
};

fileSystems."/" = {
  device = "/dev/nixvg0/root";
  fsType = "ext4";
};

fileSystems."/home" = {
  device = "/dev/nixvg0/home";
  fsType = "ext4";
};

fileSystems."/boot" = {
  device = "/dev/disk/by-partlabel/ESP";
  fsType = "vfat";
};

swapDevices = [
  { device = "/dev/nixvg0/swap"; }
];
```

### `configuration.nix` (simplified)

```nix
{
  nixpkgs.config.allowUnfree = true;

  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  users.users.yourname = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    vim git wget curl htop glxinfo
  ];

  system.stateVersion = "24.05";
}
```

---

## 🚀 Step 7: Install and Reboot

```bash
nixos-install
reboot
```

Then log in to your brand new encrypted, NVIDIA-powered, Wayland-enabled NixOS system 🎉

---

## ✅ Post-Install Tips

- Change your password: `passwd`
- Verify GPU: `nvidia-smi`
- Check session: `echo $XDG_SESSION_TYPE`
