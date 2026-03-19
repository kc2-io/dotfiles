#!/usr/bin/env bash
# =============================================================================
# .bashrc — Main bash configuration
# =============================================================================

# Dotfiles location
export DOTFILES="$HOME/.dotfiles"

# -----------------------------------------------------------------------------
# Source shared configuration
# -----------------------------------------------------------------------------
[ -f "$DOTFILES/shared/exports.sh" ] && source "$DOTFILES/shared/exports.sh"
[ -f "$DOTFILES/shared/aliases.sh" ] && source "$DOTFILES/shared/aliases.sh"
[ -f "$DOTFILES/shared/functions.sh" ] && source "$DOTFILES/shared/functions.sh"

# -----------------------------------------------------------------------------
# Platform detection and OS-specific config
# -----------------------------------------------------------------------------
case "$(uname -s)" in
    Darwin)
        [ -f "$DOTFILES/os/mac/mac.sh" ] && source "$DOTFILES/os/mac/mac.sh"
        ;;
    Linux)
        if grep -qi microsoft /proc/version 2>/dev/null; then
            # WSL (Windows Subsystem for Linux)
            [ -f "$DOTFILES/os/wsl/wsl.sh" ] && source "$DOTFILES/os/wsl/wsl.sh"
        elif [ -f /etc/debian_version ]; then
            # Debian-based Linux
            [ -f "$DOTFILES/os/debian/debian.sh" ] && source "$DOTFILES/os/debian/debian.sh"
        else
            # Generic Linux
            [ -f "$DOTFILES/os/linux/linux.sh" ] && source "$DOTFILES/os/linux/linux.sh"
        fi
        ;;
esac

# -----------------------------------------------------------------------------
# PATH additions (uncomment as needed)
# -----------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# -----------------------------------------------------------------------------
# Tool initializations (uncomment as needed)
# -----------------------------------------------------------------------------
eval "$(starship init bash)"
# eval "$(zoxide init bash)"

# # nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# # pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

# -----------------------------------------------------------------------------
# Local overrides (not committed)
# -----------------------------------------------------------------------------
[ -f "$HOME/.env.local" ] && source "$HOME/.env.local"
