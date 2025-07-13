# 🧭 NixOS Configuration — Flakes + LVM + LUKS + Home Manager

Welcome to the configuration repository for a NixOS system using flakes, full disk encryption with LUKS, and logical volume management (LVM). This project is built to support clean, reproducible, and modular system management using Git and Home Manager.

---

## 🖥️ System Overview

- **Host:** `nixblade`
- **Hostname:** `nixos`
- **User:** `xpie`
- **NixOS Version:** `25.05`
- **Shell:** `zsh`
- **Bootloader:** GRUB
- **Disk Setup:** LUKS-encrypted LVM across two NVMe drives
- **Flakes & Home Manager:** Enabled

---

## 💾 Disk & Volume Layout

### Devices:
- `/dev/nvme1n1`: 4TB NVMe
- `/dev/nvme0n1`: 2TB NVMe

### Volume Group: `nixvg0`
- `nixvg0/root` → `/`
- `nixvg0/home` → `/home`
- `nixvg0/swap` → swap (for 32GB RAM)

---

## 👤 User Configuration

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

---

## 🔧 Configuration Highlights

- Flake structure with `flake.nix`, `flake.lock`
- Host-specific config in `hosts/nixblade.nix`
- `hardware-configuration.nix` colocated in the same directory
- `programs.zsh.enable = true` for proper shell initialization
- Git repository tracks the full setup

---

## 📘 Git Practices

- SSH-authenticated GitHub repo
- All config and logs are version-controlled
- Markdown logs kept in `/logs` or root directory

---

## 🧩 Recent Fixes & Lessons Learned

- ✅ Home Manager version aligned to `release-25.05`
- ✅ Deprecated `hardware.opengl.enable` replaced with `hardware.graphics.enable`
- ✅ GRUB and root file system issues resolved with correct module imports
- ✅ Git conflict resolution practices documented
- ✅ `pull.rebase` set to avoid divergent branch issues

---

## 🛠 Rebuild Command

```bash
sudo nixos-rebuild switch --flake .#nixblade
```

---

## 📂 Repo Structure (example)

```
.
├── flake.nix
├── flake.lock
├── hosts/
│   ├── nixblade.nix
│   └── hardware-configuration.nix
├── logs/
│   ├── nixos-flake-home-manager-log.md
│   └── nixos-project-quick-reference.md
└── README.md
```

---

Happy hacking! 🚀
