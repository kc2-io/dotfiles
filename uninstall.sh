#!/usr/bin/env bash
# =============================================================================
# uninstall.sh — Remove symlinks and restore backups
#
# Usage:
#   ./uninstall.sh            # Remove all symlinks, restore .bak files
#   ./uninstall.sh --dry-run  # Preview actions without making changes
# =============================================================================
set -e

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

# Remove symlink if it points into our dotfiles, then restore .bak if present
unlink_and_restore() {
    local dest="$1"
    local src="$2"

    # Check if it's a symlink pointing to our dotfiles
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        if [ "$DRY_RUN" = true ]; then
            info "WOULD remove symlink: $dest"
        else
            rm "$dest"
            success "Removed symlink: $dest"
        fi
    elif [ -L "$dest" ]; then
        warn "Skipping: $dest (symlink points elsewhere)"
        return
    elif [ -e "$dest" ]; then
        warn "Skipping: $dest (not a symlink)"
        return
    fi

    # Restore backup if it exists
    if [ -f "${dest}.bak" ] || [ -d "${dest}.bak" ]; then
        if [ "$DRY_RUN" = true ]; then
            info "WOULD restore backup: ${dest}.bak -> $dest"
        else
            mv "${dest}.bak" "$dest"
            success "Restored backup: $dest"
        fi
    fi
}

echo "============================================="
echo "  Dotfiles Uninstaller"
echo "  Source: $DOTFILES"
echo "============================================="
echo ""

# -----------------------------------------------------------------------------
# Remove home/ symlinks
# -----------------------------------------------------------------------------
info "Removing home/ symlinks from ~/"

for file in "$DOTFILES"/home/.*; do
    [ -f "$file" ] || continue
    basename="$(basename "$file")"
    unlink_and_restore "$HOME/$basename" "$file"
done

echo ""

# -----------------------------------------------------------------------------
# Remove config/ symlinks
# -----------------------------------------------------------------------------
info "Removing config/ symlinks from ~/.config/"

for item in "$DOTFILES"/config/*; do
    [ -e "$item" ] || continue
    basename="$(basename "$item")"
    unlink_and_restore "$HOME/.config/$basename" "$item"
done

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
    echo "  Uninstall complete."
    echo "  Backup files (.bak) have been restored."
    echo "============================================="
fi
