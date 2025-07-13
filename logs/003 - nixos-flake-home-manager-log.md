# 🚀 NixOS Flake + Home-Manager Setup & Migration Log

**Date:** 2025-07-13

This document summarizes all the major steps taken to migrate the NixOS system to a flake-based setup using Home Manager, along with fixes for key errors and issues encountered along the way.

---

## 🧱 Initial Setup

1. **Initialized Git repository**
   - Created GitHub repo and pushed `/etc/nixos` config.
   - Setup SSH key authentication for GitHub.

2. **Created flake structure**
   - Added `flake.nix` and `flake.lock`.
   - Defined `nixosConfigurations` in `flake.nix`.

3. **Moved host configuration to modular layout**
   - Created `hosts/nixblade.nix`
   - Moved `hardware-configuration.nix` into the same folder for clarity.
   - Imported `hardware-configuration.nix` inside `nixblade.nix`.

---

## 🔧 Configuration & Rebuild

1. **Set up root filesystem**
   ```nix
   fileSystems."/" = {
     device = "/dev/nixvg0/root";
     fsType = "ext4";
   };
   ```

2. **Defined GRUB boot device**
   ```nix
   boot.loader.grub.devices = [ "/dev/nvme0n1" ];
   ```

3. **Configured primary user**
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

4. **Enabled zsh shell support**
   ```nix
   programs.zsh.enable = true;
   ```

---

## ⚠️ Issues & Fixes

### ❌ Error: Root filesystem not specified
> `The ‘fileSystems’ option does not specify your root file system.`

✅ **Fix**: Ensure `fileSystems."/"` is declared in your config.

---

### ❌ Error: GRUB device not defined
> `You must set the option ‘boot.loader.grub.devices’...`

✅ **Fix**: Add `boot.loader.grub.devices = [ "/dev/nvme0n1" ];`

---

### ❌ Error: User config incomplete
> `Exactly one of isSystemUser and isNormalUser must be set.`  
> `users.users.xpie.group is unset.`

✅ **Fix**:
- Set `isNormalUser = true`
- Declare `group = "xpie"` and define `users.groups.xpie = {}`

---

### ❌ Error: Shell set to zsh but not enabled
> `programs.zsh.enable is not true`

✅ **Fix**: Add `programs.zsh.enable = true;`

---

### ❌ Git flake warning: home-manager version mismatch

✅ **Fix**:
```nix
inputs.home-manager.url = "github:nix-community/home-manager/release-25.05";
```

---

### ❌ Deprecated option warning
> `hardware.opengl.enable has been renamed to hardware.graphics.enable`

✅ **Fix**: Replace with:
```nix
hardware.graphics.enable = true;
```

---

### ❌ Git warning: divergent branches
> `Need to specify how to reconcile divergent branches`

✅ **Fix (recommended)**:
```bash
git config --global pull.rebase false
```

---

### ❌ Merge conflict in configuration.nix

✅ **Fix**:
- Manually resolved conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
- Committed resolved file

---

### ❌ Git warning: dirty working tree

✅ **Fix**:
```bash
git add .
git commit -m "Commit untracked changes"
```

---

## ✅ Final Commands

```bash
nixos-rebuild switch --flake .#nixblade
```

Keep your repo clean and document config changes over time!
