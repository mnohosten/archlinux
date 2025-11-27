#!/usr/bin/env bash
#
# Arch Linux Dotfiles Installation Script
# Idempotent - safe to run multiple times
#
set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${HOME}/.local/share/dotfiles-install.log"
NVIM_REPO="https://github.com/mnohosten/nvim.git"
NVIM_DIR="${HOME}/.config/nvim"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Stow packages to install
STOW_PACKAGES=(shell i3 i3status kitty picom autorandr btop xresources git scripts systemd)

# Global for sudo keepalive cleanup
SUDO_KEEPALIVE_PID=""

cleanup() {
    if [[ -n "$SUDO_KEEPALIVE_PID" ]] && kill -0 "$SUDO_KEEPALIVE_PID" 2>/dev/null; then
        kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    fi
}
trap cleanup EXIT

# ============================================================================
# LOGGING FUNCTIONS
# ============================================================================

log_info() {
    local msg="[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1"
    echo -e "${BLUE}${msg}${NC}"
    echo "$msg" >> "$LOG_FILE"
}

log_success() {
    local msg="[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') - $1"
    echo -e "${GREEN}${msg}${NC}"
    echo "$msg" >> "$LOG_FILE"
}

log_warn() {
    local msg="[WARN] $(date '+%Y-%m-%d %H:%M:%S') - $1"
    echo -e "${YELLOW}${msg}${NC}"
    echo "$msg" >> "$LOG_FILE"
}

log_error() {
    local msg="[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1"
    echo -e "${RED}${msg}${NC}" >&2
    echo "$msg" >> "$LOG_FILE"
}

# ============================================================================
# PRE-FLIGHT CHECKS
# ============================================================================

preflight_checks() {
    log_info "Running pre-flight checks..."

    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        log_error "This script must NOT be run as root."
        log_error "Run as your regular user - sudo will be used when needed."
        exit 1
    fi

    # Check if this is Arch Linux
    if [[ ! -f /etc/arch-release ]]; then
        log_error "This script is designed for Arch Linux only."
        exit 1
    fi

    # Check if sudo is available
    if ! command -v sudo &> /dev/null; then
        log_error "sudo is not installed. Please install sudo first."
        exit 1
    fi

    # Test sudo access
    log_info "Requesting sudo access (you may be prompted for password)..."
    if [[ -t 0 ]]; then
        # Interactive mode - normal sudo
        if ! sudo -v; then
            log_error "Unable to obtain sudo privileges."
            exit 1
        fi
    else
        # Non-interactive mode - read password from stdin
        if ! sudo -S -v 2>/dev/null; then
            log_error "Unable to obtain sudo privileges. For non-interactive mode, pipe password: echo 'pass' | ./install.sh"
            exit 1
        fi
    fi

    # Keep sudo alive in background
    (while true; do sudo -n true; sleep 50; done) &
    SUDO_KEEPALIVE_PID=$!

    # Check for git
    if ! command -v git &> /dev/null; then
        log_error "git is not installed. Installing base-devel first..."
        sudo pacman -S --noconfirm git
    fi

    # Check internet connectivity
    if ! ping -c 1 archlinux.org &> /dev/null; then
        log_error "No internet connectivity. Please check your connection."
        exit 1
    fi

    # Ensure log directory exists
    mkdir -p "$(dirname "$LOG_FILE")"

    log_success "All pre-flight checks passed."
}

# ============================================================================
# PACKAGE INSTALLATION
# ============================================================================

sync_pacman_database() {
    log_info "Synchronizing pacman database..."
    sudo pacman -Sy --noconfirm
    log_success "Pacman database synchronized."
}

install_pacman_packages() {
    log_info "Installing official packages..."

    local pkg_dir="${SCRIPT_DIR}/packages"
    local all_packages=()

    # Read all .pkg files except aur.pkg
    for pkg_file in "$pkg_dir"/*.pkg; do
        [[ "$(basename "$pkg_file")" == "aur.pkg" ]] && continue
        [[ ! -f "$pkg_file" ]] && continue

        while IFS= read -r line || [[ -n "$line" ]]; do
            # Skip comments and empty lines
            [[ "$line" =~ ^[[:space:]]*# ]] && continue
            [[ -z "${line// }" ]] && continue
            # Extract package name (before any comment)
            local pkg
            pkg=$(echo "$line" | cut -d'#' -f1 | tr -d ' ')
            [[ -n "$pkg" ]] && all_packages+=("$pkg")
        done < "$pkg_file"
    done

    if [[ ${#all_packages[@]} -eq 0 ]]; then
        log_warn "No packages found in package files."
        return 0
    fi

    log_info "Found ${#all_packages[@]} packages to check."

    # Install packages (--needed skips already installed)
    if sudo pacman -S --noconfirm --needed "${all_packages[@]}"; then
        log_success "Official packages installed successfully."
    else
        log_warn "Some packages may have failed. Check the log."
    fi
}

install_yay() {
    log_info "Checking for yay AUR helper..."

    if command -v yay &> /dev/null; then
        log_success "yay is already installed."
        return 0
    fi

    log_info "Installing yay from AUR..."

    local yay_dir="/tmp/yay-install-$$"

    # Ensure base-devel is installed
    sudo pacman -S --noconfirm --needed base-devel git

    # Clone and build yay
    git clone https://aur.archlinux.org/yay.git "$yay_dir"
    (cd "$yay_dir" && makepkg -si --noconfirm)
    rm -rf "$yay_dir"

    if command -v yay &> /dev/null; then
        log_success "yay installed successfully."
    else
        log_error "Failed to install yay."
        return 1
    fi
}

install_aur_packages() {
    log_info "Installing AUR packages..."

    local pkg_file="${SCRIPT_DIR}/packages/aur.pkg"

    if [[ ! -f "$pkg_file" ]]; then
        log_warn "AUR package file not found."
        return 0
    fi

    local packages=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// }" ]] && continue
        local pkg
        pkg=$(echo "$line" | cut -d'#' -f1 | tr -d ' ')
        # Skip yay itself (already installed)
        [[ "$pkg" == "yay" ]] && continue
        [[ -n "$pkg" ]] && packages+=("$pkg")
    done < "$pkg_file"

    if [[ ${#packages[@]} -eq 0 ]]; then
        log_warn "No AUR packages to install."
        return 0
    fi

    log_info "Installing ${#packages[@]} AUR packages..."

    if yay -S --noconfirm --needed "${packages[@]}"; then
        log_success "AUR packages installed successfully."
    else
        log_warn "Some AUR packages may have failed."
    fi
}

# ============================================================================
# DIRECTORY SETUP
# ============================================================================

create_directories() {
    log_info "Creating required directories..."

    local dirs=(
        "${HOME}/Pictures/Wallpapers"
        "${HOME}/Pictures/Screenshots"
        "${HOME}/.local/bin"
        "${HOME}/.local/share"
        "${HOME}/.config"
    )

    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            log_info "Created: $dir"
        fi
    done

    log_success "Directories ready."
}

# ============================================================================
# GNU STOW OPERATIONS
# ============================================================================

stow_packages() {
    log_info "Symlinking dotfiles using GNU Stow..."

    if ! command -v stow &> /dev/null; then
        log_error "GNU Stow is not installed."
        return 1
    fi

    for pkg in "${STOW_PACKAGES[@]}"; do
        if [[ -d "${SCRIPT_DIR}/${pkg}" ]]; then
            log_info "Stowing package: $pkg"

            # Use --restow for idempotency
            if stow -v -d "$SCRIPT_DIR" -t "$HOME" --restow "$pkg" 2>> "$LOG_FILE"; then
                log_success "Stowed: $pkg"
            else
                log_warn "Could not stow $pkg - may have conflicts"
            fi
        else
            log_warn "Stow package not found: $pkg"
        fi
    done

    log_success "Dotfiles symlinked."
}

# ============================================================================
# OH MY ZSH + POWERLEVEL10K
# ============================================================================

install_oh_my_zsh() {
    log_info "Setting up Oh My Zsh..."

    local omz_dir="${HOME}/.oh-my-zsh"

    if [[ -d "$omz_dir" ]]; then
        log_success "Oh My Zsh is already installed."
        return 0
    fi

    log_info "Installing Oh My Zsh..."

    # Backup existing .zshrc if it exists
    [[ -f "${HOME}/.zshrc" ]] && mv "${HOME}/.zshrc" "${HOME}/.zshrc.pre-ohmyzsh"

    # Non-interactive installation
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Restore our .zshrc (stow will have created a symlink)
    [[ -f "${HOME}/.zshrc.pre-ohmyzsh" ]] && rm -f "${HOME}/.zshrc.pre-ohmyzsh"

    log_success "Oh My Zsh installed."
}

install_powerlevel10k() {
    log_info "Setting up Powerlevel10k theme..."

    local p10k_dir="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k"

    if [[ -d "$p10k_dir" ]]; then
        log_info "Powerlevel10k already installed, updating..."
        git -C "$p10k_dir" pull --ff-only 2>/dev/null || log_warn "Could not update Powerlevel10k"
    else
        log_info "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    fi

    log_success "Powerlevel10k theme ready."
}

# ============================================================================
# NEOVIM CONFIGURATION
# ============================================================================

setup_neovim_config() {
    log_info "Setting up Neovim configuration..."

    if [[ -d "$NVIM_DIR" ]]; then
        if [[ -d "${NVIM_DIR}/.git" ]]; then
            local remote_url
            remote_url=$(git -C "$NVIM_DIR" remote get-url origin 2>/dev/null || echo "")

            if [[ "$remote_url" == *"mnohosten/nvim"* ]]; then
                log_info "Neovim config exists, pulling latest..."
                git -C "$NVIM_DIR" pull --ff-only 2>/dev/null || log_warn "Could not pull nvim config"
                log_success "Neovim configuration updated."
                return 0
            fi
        fi

        # Backup existing config
        local backup_dir="${NVIM_DIR}.backup.$(date +%Y%m%d%H%M%S)"
        log_warn "Existing nvim config found, backing up to $backup_dir"
        mv "$NVIM_DIR" "$backup_dir"
    fi

    log_info "Cloning Neovim configuration..."
    git clone "$NVIM_REPO" "$NVIM_DIR"
    log_success "Neovim configuration installed."
}

# ============================================================================
# SYSTEMD USER SERVICES
# ============================================================================

enable_user_services() {
    log_info "Enabling systemd user services..."

    systemctl --user daemon-reload

    local services=("wallpaper-rotator.service" "autorandr.service")

    for service in "${services[@]}"; do
        local service_file="${HOME}/.config/systemd/user/${service}"

        if [[ -f "$service_file" ]] || [[ -L "$service_file" ]]; then
            log_info "Enabling service: $service"
            systemctl --user enable "$service" 2>> "$LOG_FILE" || log_warn "Could not enable $service"
        else
            log_warn "Service file not found: $service"
        fi
    done

    log_success "User services configured."
}

# ============================================================================
# POST-INSTALL CONFIGURATION
# ============================================================================

set_executable_permissions() {
    log_info "Setting executable permissions on scripts..."

    local bin_dir="${HOME}/.local/bin"

    if [[ -d "$bin_dir" ]]; then
        find "$bin_dir" -type f -exec chmod +x {} \;
        log_success "Script permissions set."
    fi
}

change_default_shell() {
    log_info "Checking default shell..."

    local current_shell
    current_shell=$(getent passwd "$USER" | cut -d: -f7)

    if [[ "$current_shell" == */zsh ]]; then
        log_success "Default shell is already zsh."
        return 0
    fi

    local zsh_path
    zsh_path=$(command -v zsh)

    if [[ -z "$zsh_path" ]]; then
        log_error "zsh is not installed."
        return 1
    fi

    log_info "Changing default shell to zsh..."

    # Ensure zsh is in /etc/shells
    if ! grep -q "^${zsh_path}$" /etc/shells; then
        echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
    fi

    if chsh -s "$zsh_path"; then
        log_success "Default shell changed to zsh. Log out and back in."
    else
        log_warn "Could not change shell. Run manually: chsh -s $zsh_path"
    fi
}

configure_git() {
    log_info "Checking git configuration..."

    local gitconfig="${HOME}/.gitconfig"

    if [[ -f "$gitconfig" ]] && grep -q "<YOUR_EMAIL>" "$gitconfig"; then
        echo ""
        echo -e "${YELLOW}Git configuration needs your details:${NC}"
        read -rp "Enter your Git email: " git_email
        read -rp "Enter your Git name: " git_name

        sed -i "s/<YOUR_EMAIL>/${git_email}/" "$gitconfig"
        sed -i "s/<YOUR_NAME>/${git_name}/" "$gitconfig"

        log_success "Git configured with your details."
    else
        log_success "Git already configured."
    fi
}

# ============================================================================
# SYSTEM SERVICES
# ============================================================================

enable_ssh_server() {
    log_info "Enabling SSH server..."

    if systemctl is-enabled sshd &>/dev/null; then
        log_success "SSH server is already enabled."
    else
        sudo systemctl enable sshd
        sudo systemctl start sshd
        log_success "SSH server enabled and started."
    fi
}

setup_docker_group() {
    log_info "Setting up Docker for non-root usage..."

    # Add user to docker group
    if groups "$USER" | grep -q docker; then
        log_success "User is already in docker group."
    else
        sudo usermod -aG docker "$USER"
        log_success "Added $USER to docker group."
        log_warn "Log out and back in for docker group to take effect."
    fi

    # Ensure docker service is enabled
    if ! systemctl is-enabled docker &>/dev/null; then
        sudo systemctl enable docker
        log_info "Docker service enabled."
    fi
}

# ============================================================================
# DEVELOPMENT ENVIRONMENT SETUP
# ============================================================================

setup_nvm_node() {
    log_info "Setting up NVM and Node.js..."

    local nvm_dir="${HOME}/.nvm"

    # Install NVM if not present
    if [[ ! -d "$nvm_dir" ]]; then
        log_info "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    fi

    # Source NVM (disable strict mode temporarily as NVM uses unset variables)
    export NVM_DIR="$nvm_dir"
    set +u
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    set -u

    if ! command -v nvm &>/dev/null; then
        log_warn "NVM not available in current session. Will be available after restart."
        return 0
    fi

    # Install Node.js LTS (disable strict mode for NVM commands)
    log_info "Installing Node.js LTS..."
    set +u
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'
    set -u

    log_success "Node.js LTS installed: $(node --version)"
}

install_claude_code() {
    log_info "Installing Claude Code..."

    # Source NVM if available (disable strict mode temporarily)
    export NVM_DIR="${HOME}/.nvm"
    set +u
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    set -u

    if ! command -v npm &>/dev/null; then
        log_warn "npm not available. Claude Code installation skipped."
        log_warn "Run 'npm install -g @anthropic-ai/claude-code' after restart."
        return 0
    fi

    if command -v claude &>/dev/null; then
        log_success "Claude Code is already installed."
        return 0
    fi

    npm install -g @anthropic-ai/claude-code
    log_success "Claude Code installed."
}

setup_rust() {
    log_info "Setting up Rust toolchain..."

    if command -v rustc &>/dev/null; then
        log_success "Rust is already installed: $(rustc --version)"
        return 0
    fi

    if ! command -v rustup &>/dev/null; then
        log_warn "rustup not installed. Install via pacman first."
        return 0
    fi

    # Initialize Rust stable toolchain
    rustup default stable
    log_success "Rust stable toolchain installed: $(rustc --version)"
}

# ============================================================================
# MAIN
# ============================================================================

print_banner() {
    echo -e "${BLUE}"
    cat << 'EOF'
    _             _       _     _
   / \   _ __ ___| |__   | |   (_)_ __  _   ___  __
  / _ \ | '__/ __| '_ \  | |   | | '_ \| | | \ \/ /
 / ___ \| | | (__| | | | | |___| | | | | |_| |>  <
/_/   \_\_|  \___|_| |_| |_____|_|_| |_|\__,_/_/\_\

         ____        _    __ _ _
        |  _ \  ___ | |_ / _(_) | ___  ___
        | | | |/ _ \| __| |_| | |/ _ \/ __|
        | |_| | (_) | |_|  _| | |  __/\__ \
        |____/ \___/ \__|_| |_|_|\___||___/

EOF
    echo -e "${NC}"
    echo "Idempotent installation - safe to run multiple times"
    echo "======================================================"
    echo ""
}

main() {
    print_banner

    log_info "Starting dotfiles installation..."
    log_info "Log file: $LOG_FILE"

    # Phase 1: Pre-flight checks
    preflight_checks

    # Phase 2: System packages
    sync_pacman_database
    install_pacman_packages

    # Phase 3: AUR
    install_yay
    install_aur_packages

    # Phase 4: Directories
    create_directories

    # Phase 5: Stow dotfiles
    stow_packages

    # Phase 6: Oh My Zsh + Powerlevel10k
    install_oh_my_zsh
    install_powerlevel10k

    # Phase 7: Neovim
    setup_neovim_config

    # Phase 8: Permissions
    set_executable_permissions

    # Phase 9: User services
    enable_user_services

    # Phase 10: System services (SSH)
    enable_ssh_server

    # Phase 11: Docker setup
    setup_docker_group

    # Phase 12: Development environment
    setup_nvm_node
    install_claude_code
    setup_rust

    # Phase 13: Git config
    configure_git

    # Phase 14: Shell
    change_default_shell

    echo ""
    log_success "============================================"
    log_success "Installation complete!"
    log_success "============================================"
    echo ""
    echo "Next steps:"
    echo "  1. Log out and back in for shell/docker group changes"
    echo "  2. Run 'p10k configure' if you want to customize your prompt"
    echo "  3. Open nvim to let plugins install"
    echo "  4. Add wallpapers to ~/Pictures/Wallpapers"
    echo ""
    echo "Installed development tools:"
    echo "  - Node.js LTS via nvm (run 'nvm use --lts')"
    echo "  - Claude Code (run 'claude' to start)"
    echo "  - Rust via rustup"
    echo "  - Java, Go, Python, PHP, Lua"
    echo ""
    echo "Services enabled:"
    echo "  - SSH server (sshd)"
    echo "  - Docker (user added to docker group)"
    echo ""
    echo "Log file: $LOG_FILE"
}

main "$@"
