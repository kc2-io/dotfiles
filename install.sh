#!/usr/bin/env bash
# =============================================================================
# install.sh — Bootstrap dotfiles for macOS, Linux, Debian, and WSL
#
# Usage:
#   ./install.sh            # Install everything
#   ./install.sh --dry-run  # Preview actions without making changes
# =============================================================================
set -e

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=false

if [ "$1" = "--dry-run" ]; then
    DRY_RUN=true
    echo "=== DRY RUN — no changes will be made ==="
    echo ""
fi

# -----------------------------------------------------------------------------
# Helper functions
# -----------------------------------------------------------------------------
info() {
    printf "\033[1;34m[INFO]\033[0m %s\n" "$1"
}

success() {
    printf "\033[1;32m[OK]\033[0m   %s\n" "$1"
}

warn() {
    printf "\033[1;33m[WARN]\033[0m %s\n" "$1"
}

error() {
    printf "\033[1;31m[ERR]\033[0m  %s\n" "$1"
}

# Back up a file if it exists and is not already a symlink to our dotfiles
backup_and_link() {
    local src="$1"
    local dest="$2"

    if [ "$DRY_RUN" = true ]; then
        if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
            info "SKIP (already linked): $dest -> $src"
        elif [ -e "$dest" ] || [ -L "$dest" ]; then
            info "WOULD backup: $dest -> ${dest}.bak"
            info "WOULD link:   $dest -> $src"
        else
            info "WOULD link:   $dest -> $src"
        fi
        return
    fi

    # Already correctly linked
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        success "Already linked: $dest"
        return
    fi

    # Back up existing file/symlink
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        warn "Backing up: $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # Create symlink
    ln -s "$src" "$dest"
    success "Linked: $dest -> $src"
}

# -----------------------------------------------------------------------------
# Platform detection
# -----------------------------------------------------------------------------
detect_platform() {
    case "$(uname -s)" in
        Darwin)
            echo "mac"
            ;;
        Linux)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            elif [ -f /etc/debian_version ]; then
                echo "debian"
            else
                echo "linux"
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

PLATFORM="$(detect_platform)"

echo "============================================="
echo "  Dotfiles Installer"
echo "  Platform: $PLATFORM"
echo "  Source:   $DOTFILES"
echo "============================================="
echo ""

# -----------------------------------------------------------------------------
# Symlink home/ files to ~/
# -----------------------------------------------------------------------------
info "Linking home/ files to ~/"

for file in "$DOTFILES"/home/.*; do
    [ -f "$file" ] || continue
    basename="$(basename "$file")"
    backup_and_link "$file" "$HOME/$basename"
done

echo ""

# -----------------------------------------------------------------------------
# Symlink config/ items to ~/.config/
# -----------------------------------------------------------------------------
info "Linking config/ items to ~/.config/"

if [ "$DRY_RUN" = false ]; then
    mkdir -p "$HOME/.config"
fi

for item in "$DOTFILES"/config/*; do
    [ -e "$item" ] || continue
    basename="$(basename "$item")"
    backup_and_link "$item" "$HOME/.config/$basename"
done

echo ""

# -----------------------------------------------------------------------------
# Run platform-specific setup
# -----------------------------------------------------------------------------
info "Running $PLATFORM setup..."

run_platform_script() {
    local script="$1"
    if [ -f "$script" ]; then
        if [ "$DRY_RUN" = true ]; then
            info "WOULD source: $script"
        else
            info "Sourcing: $script"
            source "$script"
        fi
    else
        warn "No platform script found at: $script"
    fi
}

case "$PLATFORM" in
    mac)
        run_platform_script "$DOTFILES/os/mac/mac.sh"
        ;;
    wsl)
        run_platform_script "$DOTFILES/os/wsl/wsl.sh"
        ;;
    debian)
        run_platform_script "$DOTFILES/os/debian/debian.sh"
        ;;
    linux)
        run_platform_script "$DOTFILES/os/linux/linux.sh"
        ;;
    *)
        warn "Unknown platform: $PLATFORM — skipping OS-specific setup"
        ;;
esac

echo ""

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
if [ "$DRY_RUN" = true ]; then
    echo "============================================="
    echo "  Dry run complete. No changes were made."
    echo "============================================="
else
    echo "============================================="
    echo "  Installation complete!"
    echo "  Restart your shell or run: source ~/.zshrc"
    echo "============================================="
fi
