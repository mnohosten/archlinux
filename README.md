# Arch Linux Dotfiles

Personal Arch Linux configuration with i3 window manager, managed using GNU Stow.

![i3 Status Bar](docs/assets/statusbar.png)

## Features

- **i3 Window Manager** with One Dark Pro theme
- **Kitty Terminal** with Monokai Pro colors and transparency
- **Zsh** with Oh My Zsh and Powerlevel10k
- **Full Development Environment** (Node.js, Python, Java, Rust, Go, PHP, Lua)
- **Database Stack** (MariaDB, PostgreSQL, MongoDB, Valkey, NATS)
- **Docker** configured for non-root usage
- **~190 carefully selected packages** organized by category

## Installation

### Prerequisites

- **Arch Linux** - Fresh install or existing system
- **Internet connection** - Required for package downloads
- **Non-root user with sudo** - The installer uses sudo when needed
- **Git** - To clone the repository

### Fresh Arch Linux Install

If starting from a minimal Arch Linux installation:

```bash
# 1. Install git (if not already installed)
sudo pacman -S git

# 2. Clone this repository
git clone https://github.com/mnohosten/archlinux ~/dotfiles

# 3. Run the installer
cd ~/dotfiles
./install.sh

# 4. Log out and back in for all changes to take effect
```

### Existing System Install

Works on any Arch Linux system. Existing configs will be backed up.

```bash
git clone https://github.com/mnohosten/archlinux ~/dotfiles
cd ~/dotfiles
./install.sh
```

### What the Installer Does

The `install.sh` script performs these steps automatically:

| Phase | Action |
|-------|--------|
| 1 | Pre-flight checks (Arch Linux, sudo, internet) |
| 2 | Install ~190 packages from official repos |
| 3 | Install yay AUR helper |
| 4 | Install AUR packages (Chrome, 1Password, MongoDB, etc.) |
| 5 | Create required directories |
| 6 | Symlink all dotfiles using GNU Stow |
| 7 | Install Oh My Zsh + Powerlevel10k theme |
| 8 | Clone Neovim configuration |
| 9 | Install Node.js LTS via NVM |
| 10 | Install Claude Code CLI |
| 11 | Initialize Rust toolchain |
| 12 | Enable SSH server |
| 13 | Add user to docker group |
| 14 | Enable systemd user services |
| 15 | Configure Git (prompts for name/email) |
| 16 | Change default shell to Zsh |

### Post-Installation

After installation completes:

```bash
# 1. Log out and back in (required for shell and docker group)

# 2. Add wallpapers for rotation
cp /path/to/wallpapers/* ~/Pictures/Wallpapers/

# 3. Open Neovim to install plugins
nvim

# 4. (Optional) If using display hotplug, edit the handler script
vim ~/.local/bin/i3-display-handler.sh
# Replace <YOUR_USERNAME> with your actual username
```

### Partial Installation

To install only specific components:

```bash
cd ~/dotfiles

# Install only specific stow packages
stow -t ~ shell kitty i3

# Install only specific package categories
sudo pacman -S --needed $(grep -v '^#' packages/cli-tools.pkg | cut -d'#' -f1)
```

## Documentation

| Document | Description |
|----------|-------------|
| [Installation Guide](docs/INSTALLATION.md) | Detailed setup instructions |
| [Keyboard Shortcuts](docs/KEYBINDINGS.md) | All i3 keybindings |
| [Package Lists](docs/PACKAGES.md) | All packages by category |
| [Theming & Colors](docs/THEMING.md) | Color schemes and fonts |
| [Custom Scripts](docs/SCRIPTS.md) | Script documentation |

## What's Included

### Desktop Environment
| Component | Tool | Theme/Config |
|-----------|------|--------------|
| Window Manager | i3 | One Dark Pro |
| Status Bar | i3status | SynthWave '84 |
| Terminal | Kitty | Monokai Pro, 90% opacity |
| Compositor | picom | Shadows, transparency |
| Launcher | dmenu | Default |
| Font | Cascadia Code NF | Size 11 |

### Development Stack
| Category | Tools |
|----------|-------|
| **Languages** | Node.js (LTS/NVM), Python 3, Java (OpenJDK), Rust, Go, PHP, Lua |
| **Package Managers** | npm, pip/poetry/pipx, maven/gradle, cargo, composer, luarocks |
| **Databases** | MariaDB, PostgreSQL, MongoDB, Valkey (Redis), NATS |
| **Infrastructure** | Docker, Terraform, Ansible |
| **Editors** | Neovim ([separate repo](https://github.com/mnohosten/nvim)) |

### Key Shortcuts

| Shortcut | Action |
|----------|--------|
| `$mod+Return` | Open terminal |
| `$mod+d` | Application launcher |
| `$mod+Shift+q` | Close window |
| `$mod+1-0` | Switch workspace |
| `$mod+Shift+1-0` | Move to workspace |
| `Alt+Shift+4` | Screenshot area |
| `$mod+Shift+e` | Exit i3 |

> `$mod` = Super/Windows key. See [full keybindings](docs/KEYBINDINGS.md).

## Repository Structure

```
.
├── install.sh              # Main installation script
├── uninstall.sh            # Remove symlinks
├── README.md               # This file
├── docs/                   # Documentation
│   ├── INSTALLATION.md     # Setup guide
│   ├── KEYBINDINGS.md      # Keyboard shortcuts
│   ├── PACKAGES.md         # Package documentation
│   ├── THEMING.md          # Colors and fonts
│   └── SCRIPTS.md          # Script documentation
│
├── packages/               # Package lists (~190 packages)
│   ├── base.pkg            # Core system
│   ├── desktop.pkg         # i3, audio, display
│   ├── development.pkg     # Languages, LSPs, tools
│   ├── databases.pkg       # MariaDB, PostgreSQL, Valkey
│   ├── cli-tools.pkg       # Modern CLI utilities
│   ├── networking.pkg      # Network tools
│   ├── applications.pkg    # GUI apps
│   ├── printing.pkg        # CUPS printing
│   ├── fonts.pkg           # Typography
│   ├── drivers.pkg         # GPU drivers
│   └── aur.pkg             # AUR packages
│
├── shell/                  # Zsh/Bash configs
├── i3/                     # i3 window manager
├── i3status/               # Status bar
├── kitty/                  # Terminal emulator
├── picom/                  # Compositor
├── autorandr/              # Display profiles
├── btop/                   # System monitor
├── xresources/             # X11 resources
├── git/                    # Git configuration
├── scripts/                # Custom scripts
└── systemd/                # User services
```

## Post-Installation

After running `install.sh` and logging back in:

1. **Add wallpapers** to `~/Pictures/Wallpapers/`
2. **Open Neovim** to install plugins: `nvim`
3. **Configure displays** (if needed): `$mod+Shift+d`
4. **Edit display handler** (for udev): Replace `<YOUR_USERNAME>` in `~/.local/bin/i3-display-handler.sh`

## Customization

### Change Theme Colors

Edit the color variables in:
- `i3/.config/i3/config` - Window manager colors
- `kitty/.config/kitty/kitty.conf` - Terminal colors
- `i3status/.config/i3status/config` - Status bar colors

See [Theming Guide](docs/THEMING.md) for details.

### Add/Remove Packages

```bash
# Add package to appropriate .pkg file
echo "package-name    # Description" >> packages/cli-tools.pkg

# Install immediately
sudo pacman -S package-name
```

### Stow Operations

```bash
cd ~/dotfiles

# Apply single config
stow -t ~ i3

# Remove single config
stow -t ~ -D i3

# Reapply after changes
stow -t ~ --restow i3
```

## Services

### Enabled by Default
- `sshd` - SSH server
- `docker` - Container runtime
- `wallpaper-rotator` - Wallpaper rotation (user service)
- `autorandr` - Display detection (user service)

### Database Services (start manually)
```bash
sudo systemctl start mariadb
sudo systemctl start mongodb
sudo systemctl start valkey
sudo systemctl start nats-server
```

## Requirements

- Arch Linux (fresh install or existing)
- Internet connection
- Non-root user with sudo access
- ~5GB disk space for packages

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

- [i3wm](https://i3wm.org/) - Window manager
- [Oh My Zsh](https://ohmyz.sh/) - Zsh framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme
- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink manager
