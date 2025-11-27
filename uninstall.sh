#!/usr/bin/env bash
#
# Uninstall dotfiles - removes symlinks created by stow
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_PACKAGES=(shell i3 i3status kitty picom autorandr btop xresources git scripts systemd)

echo "Removing dotfiles symlinks..."

for pkg in "${STOW_PACKAGES[@]}"; do
    if [[ -d "${SCRIPT_DIR}/${pkg}" ]]; then
        echo "Unstowing: $pkg"
        stow -v -d "$SCRIPT_DIR" -t "$HOME" -D "$pkg" 2>/dev/null || true
    fi
done

echo ""
echo "Dotfiles symlinks removed."
echo "Note: Packages, Oh My Zsh, and Neovim config are NOT removed."
