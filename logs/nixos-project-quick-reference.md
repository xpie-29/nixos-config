# 📌 NixOS Project Quick Reference: LVM + LUKS + Flakes + Home Manager

## 🖥️ System Overview
- **Host:** `nixblade`
- **Username:** `xpie`
- **Hostname:** `nixos`
- **NixOS Version:** `25.05`
- **Shell:** `zsh`
- **Boot:** GRUB
- **Encryption:** LUKS (single passphrase unlock for all volumes)
- **Partitioning:** LVM on top of LUKS

---

## 💾 Disk Layout
- `/dev/nvme1n1`: 4TB NVMe
- `/dev/nvme0n1`: 2TB NVMe
- Volume group: `nixvg0`

### Logical Volumes:
- `nixvg0/root` → `/`
- `nixvg0/home` → `/home`
- `nixvg0/swap` → swap (sized appropriately for 32GB RAM)

---

## 🔐 User Configuration
```nix
users.users.xpie = {
  isNormalUser = true;
  group = "xpie";
  home = "/home/xpie";
  shell = pkgs.zsh;
  extraGroups = [ "wheel" "networkmanager" ];
};
users.groups.xpie = {};
```

## 🔧 Zsh
```nix
programs.zsh.enable = true;
```

---

## 🧱 Configuration Structure
- Uses `flake.nix` and `flake.lock`
- Host config in: `./hosts/nixblade.nix`
- `hardware-configuration.nix` is also in `./hosts/`
- Git is set up and tracks the full config repo

---

## 📘 Git Usage
- SSH key added to GitHub
- Changes are committed and pushed regularly
- Logs and summaries are stored as `.md` files in the repo

---

## ✅ Recent Fixes Logged
- Home Manager version mismatch → fixed with `release-25.05`
- Deprecated `hardware.opengl.enable` → replaced with `hardware.graphics.enable`
- GRUB boot device and filesystem not set → now fixed in host config
- Merge conflicts and Git divergence → resolved and logged
