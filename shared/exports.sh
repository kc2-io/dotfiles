# =============================================================================
# exports.sh — Shared environment variables (POSIX-compatible)
# =============================================================================

# Dotfiles location
export DOTFILES="$HOME/.dotfiles"

# Default editor
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-$EDITOR}"

# History settings
export HISTSIZE=10000
export HISTFILESIZE=20000
export SAVEHIST=10000

# XDG base directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# PATH — add ~/.local/bin if not already present
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# Locale
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# Less (pager) — enable color and case-insensitive search
export LESS='-R -i'
