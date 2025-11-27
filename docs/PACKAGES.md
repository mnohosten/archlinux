# Package Lists

Documentation for all package categories and their contents.

## Overview

Packages are organized into `.pkg` files in the `packages/` directory. Each file contains one package per line with optional inline comments.

### Format
```
package-name            # Description of package
```

Lines starting with `#` are comments. Empty lines are ignored.

## Package Categories

### base.pkg - Core System (10 packages)

Essential packages for a bootable Arch Linux system.

| Package | Description |
|---------|-------------|
| `base` | Minimal package set |
| `base-devel` | Build tools (gcc, make, etc.) |
| `linux` | Linux kernel |
| `linux-firmware` | Firmware files |
| `intel-ucode` | Intel CPU microcode |
| `efibootmgr` | EFI boot manager |
| `acpid` | Power management daemon |
| `openssh` | SSH server and client |
| `zram-generator` | Compressed swap |

### desktop.pkg - Desktop Environment (29 packages)

i3 window manager and related components.

**Window Manager:**
- `i3-wm` - Tiling window manager
- `i3blocks` - Status bar blocks
- `i3lock` - Screen locker
- `i3status` - Status bar generator
- `dmenu` - Application launcher
- `picom` - Compositor
- `xss-lock` - Lock screen trigger
- `feh` - Wallpaper setter

**Display Manager:**
- `lightdm` - Display manager
- `lightdm-gtk-greeter` - GTK greeter

**X.org:**
- `xorg-xinit` - X initialization
- `xorg-xrandr` - Display configuration
- `xterm` - Fallback terminal
- `xdg-utils` - Desktop utilities
- `xclip` - Clipboard utility

**Audio (PipeWire):**
- `pipewire`, `pipewire-alsa`, `pipewire-jack`, `pipewire-pulse`
- `wireplumber` - Session manager
- `libpulse` - PulseAudio compatibility
- `gst-plugin-pipewire` - GStreamer integration

**Bluetooth:**
- `bluez`, `bluez-utils`, `blueman`

### development.pkg - Development Tools (47 packages)

Programming languages, build tools, and language servers.

**Version Control:**
- `git`, `git-delta`, `lazygit`, `github-cli`

**Build Systems:**
- `cmake`, `meson`, `ninja`, `clang`, `llvm`

**Languages:**
| Language | Packages |
|----------|----------|
| Java | `jdk-openjdk`, `maven`, `gradle` |
| Python | `python`, `python-pip`, `python-pipx`, `python-poetry`, `python-black` |
| Go | `go`, `gopls` |
| Rust | `rustup`, `rust-analyzer` |
| PHP | `php`, `php-gd`, `php-sqlite`, `composer` |
| Lua | `lua`, `luarocks` |

**Language Servers:**
- `bash-language-server`
- `lua-language-server`
- `pyright`
- `typescript-language-server`
- `yaml-language-server`

**Formatters & Linters:**
- `eslint`, `prettier`, `ruff`, `shellcheck`, `shfmt`, `stylua`

**Debugging:**
- `gdb`, `valgrind`, `strace`, `ltrace`, `perf`

**Infrastructure:**
- `docker`, `docker-buildx`, `docker-compose`
- `terraform`, `ansible`

### databases.pkg - Databases (5 packages)

Database servers and clients.

| Package | Description |
|---------|-------------|
| `mariadb` | MariaDB server |
| `mariadb-clients` | MariaDB CLI tools |
| `postgresql` | PostgreSQL server |
| `postgresql-libs` | PostgreSQL client |
| `valkey` | Redis-compatible store |

> MongoDB and NATS are in `aur.pkg`

### cli-tools.pkg - CLI Utilities (39 packages)

Modern command-line tools.

**Modern Replacements:**
| Tool | Replaces | Command |
|------|----------|---------|
| `bat` | cat | Syntax highlighting |
| `eza` | ls | Better listing |
| `fd` | find | Fast file finder |
| `ripgrep` | grep | Fast search (rg) |
| `sd` | sed | Easier sed |
| `dust` | du | Disk usage |
| `duf` | df | Disk free |
| `procs` | ps | Process viewer |
| `bottom` | htop | System monitor (btm) |
| `zoxide` | cd | Smart cd (z) |

**File Managers:**
- `ranger`, `lf`, `nnn`, `mc`

**Shell:**
- `zsh`, `starship`, `tmux`, `fzf`

**Editors:**
- `neovim`, `vim`, `nano`

**Data Processing:**
- `jq`, `miller`, `grex`

**Utilities:**
- `tree`, `ncdu`, `tldr`, `tokei`, `hyperfine`, `pandoc-cli`, `lnav`, `rsync`

**Backup:**
- `borg`, `rclone`, `restic`

### networking.pkg - Network Tools (22 packages)

Network diagnostics and utilities.

**Wireless:**
- `iwd`, `iw`, `wpa_supplicant`, `wireless_tools`, `net-tools`

**Bluetooth:**
- `bluez`, `bluez-utils`, `blueman`

**DNS & HTTP:**
- `bind` (dig), `dog`, `httpie`, `xh`, `wget`

**Diagnostics:**
- `nmap`, `mtr`, `traceroute`, `tcpdump`
- `wireshark-cli`, `wireshark-qt`
- `iftop`, `bandwhich`, `iperf3`

**Utilities:**
- `openbsd-netcat`, `socat`, `nss-mdns`

### applications.pkg - GUI Applications (11 packages)

Desktop applications.

| Package | Description |
|---------|-------------|
| `firefox` | Web browser |
| `thunderbird` | Email client |
| `signal-desktop` | Secure messaging |
| `kodi` | Media center |
| `alacritty` | Terminal emulator |
| `kitty` | Terminal emulator |
| `maim` | Screenshot tool |
| `slop` | Region selection |

### printing.pkg - Printing (14 packages)

CUPS printing subsystem.

- `cups`, `cups-browsed`, `cups-pdf`
- Foomatic drivers and PPDs
- `gutenprint`, `hplip`
- `sane`, `sane-airscan`, `simple-scan`

### fonts.pkg - Typography (8 packages)

Coding and system fonts.

| Package | Description |
|---------|-------------|
| `ttf-cascadia-code` | Microsoft Cascadia Code + NF |
| `ttf-fira-code` | Fira Code with ligatures |
| `ttf-hack` | Hack coding font |
| `ttf-jetbrains-mono` | JetBrains Mono |
| `ttf-meslo-nerd` | Meslo Nerd Font |
| `ttf-dejavu` | DejaVu family |
| `ttf-liberation` | Liberation fonts |
| `noto-fonts-emoji` | Emoji support |

### drivers.pkg - GPU Drivers (8 packages)

Graphics drivers for Intel, AMD, NVIDIA.

**Intel:**
- `intel-media-driver`, `libva-intel-driver`, `vulkan-intel`

**AMD:**
- `vulkan-radeon`, `xf86-video-amdgpu`, `xf86-video-ati`

**NVIDIA (Nouveau):**
- `vulkan-nouveau`, `xf86-video-nouveau`

### aur.pkg - AUR Packages (6 packages)

Packages from Arch User Repository.

| Package | Description |
|---------|-------------|
| `yay` | AUR helper |
| `1password` | Password manager |
| `google-chrome` | Chrome browser |
| `slack-desktop` | Slack client |
| `mongodb-bin` | MongoDB database |
| `nats-server-bin` | NATS messaging |

## Maintenance

### Export Current Packages
```bash
# Official packages
pacman -Qqen > /tmp/native.txt

# AUR packages
pacman -Qqem > /tmp/aur.txt
```

### Find Untracked Packages
```bash
# Packages installed but not in .pkg files
comm -23 <(pacman -Qqen | sort) \
         <(cat packages/*.pkg | grep -v '^#' | grep -v '^$' | cut -d'#' -f1 | tr -d ' ' | sort -u)
```

### Add Package to List
```bash
echo "new-package         # Description" >> packages/cli-tools.pkg
```

### Install Single Category
```bash
sudo pacman -S --needed $(grep -v '^#' packages/development.pkg | cut -d'#' -f1)
```
