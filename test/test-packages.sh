#!/bin/bash
#
# Test script to verify package lists are valid
# Run this before committing changes to package files
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_DIR="${SCRIPT_DIR}/packages"

echo "=== Dotfiles Package Validation ==="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

errors=0
warnings=0

# Test 1: Check all .pkg files exist
echo "Checking package files..."
for expected in base desktop development databases cli-tools networking applications printing fonts drivers aur; do
    if [[ -f "${PKG_DIR}/${expected}.pkg" ]]; then
        echo -e "  ${GREEN}✓${NC} ${expected}.pkg"
    else
        echo -e "  ${RED}✗${NC} ${expected}.pkg missing!"
        ((errors++))
    fi
done
echo ""

# Test 2: Validate package names (no spaces, valid characters)
echo "Validating package names..."
for pkg_file in "${PKG_DIR}"/*.pkg; do
    filename=$(basename "$pkg_file")
    invalid=$(grep -v '^#' "$pkg_file" | grep -v '^$' | cut -d'#' -f1 | tr -d ' ' | grep -E '[^a-zA-Z0-9_-]' || true)
    if [[ -n "$invalid" ]]; then
        echo -e "  ${RED}✗${NC} ${filename}: Invalid package names found"
        echo "$invalid" | head -5
        ((errors++))
    else
        count=$(grep -v '^#' "$pkg_file" | grep -v '^$' | wc -l)
        echo -e "  ${GREEN}✓${NC} ${filename} (${count} packages)"
    fi
done
echo ""

# Test 3: Check for duplicates across files
echo "Checking for duplicates..."
all_packages=$(cat "${PKG_DIR}"/*.pkg | grep -v '^#' | grep -v '^$' | cut -d'#' -f1 | tr -d ' ' | sort)
duplicates=$(echo "$all_packages" | uniq -d)
if [[ -n "$duplicates" ]]; then
    echo -e "  ${YELLOW}!${NC} Duplicate packages found:"
    echo "$duplicates" | while read pkg; do
        echo "    - $pkg"
    done
    ((warnings++))
else
    echo -e "  ${GREEN}✓${NC} No duplicates"
fi
echo ""

# Test 4: Verify packages exist in repos (optional, requires pacman)
if command -v pacman &> /dev/null; then
    echo "Verifying packages exist in repos (sampling)..."
    # Only check first 10 from each file to save time
    for pkg_file in "${PKG_DIR}"/*.pkg; do
        [[ "$(basename "$pkg_file")" == "aur.pkg" ]] && continue
        sample=$(grep -v '^#' "$pkg_file" | grep -v '^$' | cut -d'#' -f1 | tr -d ' ' | head -5)
        for pkg in $sample; do
            if pacman -Si "$pkg" &>/dev/null; then
                echo -e "  ${GREEN}✓${NC} $pkg"
            else
                echo -e "  ${RED}✗${NC} $pkg not found in repos!"
                ((errors++))
            fi
        done
    done
else
    echo -e "  ${YELLOW}!${NC} pacman not available, skipping repo verification"
fi
echo ""

# Test 5: Verify stow directories
echo "Verifying stow package structure..."
for stow_pkg in shell i3 i3status kitty picom autorandr btop xresources git scripts systemd; do
    if [[ -d "${SCRIPT_DIR}/${stow_pkg}" ]]; then
        files=$(find "${SCRIPT_DIR}/${stow_pkg}" -type f | wc -l)
        echo -e "  ${GREEN}✓${NC} ${stow_pkg}/ (${files} files)"
    else
        echo -e "  ${RED}✗${NC} ${stow_pkg}/ missing!"
        ((errors++))
    fi
done
echo ""

# Summary
echo "=== Summary ==="
total_packages=$(cat "${PKG_DIR}"/*.pkg | grep -v '^#' | grep -v '^$' | wc -l)
echo "Total packages: ${total_packages}"
echo -e "Errors: ${RED}${errors}${NC}"
echo -e "Warnings: ${YELLOW}${warnings}${NC}"
echo ""

if [[ $errors -gt 0 ]]; then
    echo -e "${RED}Validation failed!${NC}"
    exit 1
else
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
fi
