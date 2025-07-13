# 📘 Git Setup and Workflow for NixOS Configuration

**Date:** 2025-07-13

## ✅ Completed Steps

1. **Installed Git** using Nix:
   ```bash
   git was one of the packages included in the initial setup.
   ```

2. **Configured Git user identity**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "you@example.com"
   ```

3. **Generated SSH key** for GitHub and added it to GitHub:
   ```bash
   ssh-keygen -t ed25519 -C "you@example.com"
   ssh-add ~/.ssh/id_ed25519
   cat ~/.ssh/id_ed25519.pub  # → Added to GitHub SSH settings
   ```

4. **Cloned or initialized** a GitHub repository:
   ```bash
   git clone git@github.com:yourusername/your-repo.git
   # or
   git init
   git remote add origin git@github.com:yourusername/your-repo.git
   ```

5. **Copied NixOS configuration files** and made the first commit:
   ```bash
   cp -r /etc/nixos/* .
   git add .
   git commit -m "Initial commit of NixOS config"
   git push -u origin main
   ```

---

## 🔁 Workflow for Pushing Updates

1. Navigate to repo:
   ```bash
   cd ~/nixos-config
   ```

2. Check changes:
   ```bash
   git status
   ```

3. Stage changes:
   ```bash
   git add .
   ```

4. Commit:
   ```bash
   git commit -m "Describe your change"
   ```

5. Push:
   ```bash
   git push
   ```

---

## 🛠 Optional Enhancements

- View history: `git log --oneline`
- Create alias:
   ```bash
   alias gp='git add . && git commit -m'
   ```
   Then push with:
   ```bash
   gp "Updated flake inputs" && git push
   ```

---

## 🧠 Notes
This log documents the setup and usage of Git for tracking NixOS configuration files and documenting the system build process. It supports SSH authentication with GitHub and a clean workflow for future commits.

