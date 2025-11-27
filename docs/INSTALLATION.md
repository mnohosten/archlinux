# Installation Guide

Complete guide for installing these dotfiles on a fresh Arch Linux system.

## Prerequisites

- Fresh Arch Linux installation with i3 (or base install)
- Non-root user with sudo access
- Internet connection
- Git installed (`pacman -S git`)

## Quick Install

```bash
git clone https://github.com/mnohosten/archlinux ~/dotfiles
cd ~/dotfiles
./install.sh
```

## What the Installer Does

The `install.sh` script performs the following steps in order:

### Phase 1: Pre-flight Checks
- Verifies running on Arch Linux
- Ensures not running as root
- Tests sudo access
- Checks internet connectivity

### Phase 2: Package Installation
- Syncs pacman database
- Installs all packages from `packages/*.pkg` files (~190 packages)
- Installs yay AUR helper
- Installs AUR packages (1Password, Chrome, MongoDB, NATS, Slack)

### Phase 3: Directory Setup
Creates required directories:
- `~/Pictures/Wallpapers` - For wallpaper rotation
- `~/Pictures/Screenshots` - For screenshot tool
- `~/.local/bin` - For custom scripts
- `~/.config` - For application configs

### Phase 4: Dotfiles Symlinking
Uses GNU Stow to create symlinks:
- `shell/` → Shell configs (.zshrc, .bashrc, .p10k.zsh)
- `i3/` → i3 window manager config
- `i3status/` → Status bar config
- `kitty/` → Terminal config
- `picom/` → Compositor config
- `autorandr/` → Display profiles
- `btop/` → System monitor config
- `xresources/` → X11 resources
- `git/` → Git config
- `scripts/` → Custom scripts
- `systemd/` → User services

### Phase 5: Shell Setup
- Installs Oh My Zsh framework
- Installs Powerlevel10k theme
- Changes default shell to Zsh

### Phase 6: Development Environment
- Installs NVM and Node.js LTS
- Installs Claude Code CLI
- Initializes Rust stable toolchain

### Phase 7: Services
- Enables SSH server (sshd)
- Adds user to docker group
- Enables user systemd services

### Phase 8: Configuration
- Prompts for Git email/name
- Sets script permissions

## Manual Steps After Installation

### 1. Log Out and Back In
Required for:
- Shell change to take effect
- Docker group membership to activate

### 2. Configure Powerlevel10k (Optional)
```bash
p10k configure
```
Or use the included `.p10k.zsh` configuration.

### 3. Set Up Neovim
Open Neovim and wait for plugins to install:
```bash
nvim
```

### 4. Add Wallpapers
Add images to `~/Pictures/Wallpapers/` for the rotation script.

### 5. Configure Display Handler
If using udev for display hotplug:
```bash
# Edit and replace <YOUR_USERNAME>
vim ~/.local/bin/i3-display-handler.sh
```

### 6. Start Services (Optional)
Database services are installed but not started by default:
```bash
# MariaDB
sudo systemctl start mariadb

# MongoDB
sudo systemctl start mongodb

# Valkey (Redis)
sudo systemctl start valkey

# NATS
sudo systemctl start nats-server
```

## Troubleshooting

### Stow Conflicts
If stow reports conflicts:
```bash
# Backup existing config
mv ~/.config/i3 ~/.config/i3.backup

# Re-run stow
cd ~/dotfiles
stow -t ~ i3
```

### Missing Fonts
If icons don't display correctly:
```bash
# Reinstall Nerd Fonts
sudo pacman -S ttf-cascadia-code ttf-meslo-nerd noto-fonts-emoji

# Rebuild font cache
fc-cache -fv
```

### Docker Permission Denied
```bash
# Verify group membership
groups $USER

# If docker not listed, re-add and reboot
sudo usermod -aG docker $USER
reboot
```

### NVM Not Found
```bash
# Source NVM manually
source ~/.nvm/nvm.sh

# Or restart terminal
```

## Uninstallation

To remove symlinks (keeps packages installed):
```bash
cd ~/dotfiles
./uninstall.sh
```

## Partial Installation

To install only specific components:
```bash
cd ~/dotfiles

# Install only specific stow packages
stow -t ~ shell kitty

# Install only specific package categories
sudo pacman -S --needed $(grep -v '^#' packages/cli-tools.pkg | cut -d'#' -f1)
```
