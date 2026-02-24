# =============================================================================
# aliases.sh — Shared aliases (POSIX-compatible, sourced by bash and zsh)
# =============================================================================

# -----------------------------------------------------------------------------
# Dotfiles management
# -----------------------------------------------------------------------------
alias dots='cd "$DOTFILES" && git status'
alias dots-pull='git -C "$DOTFILES" pull'
alias dots-edit='${EDITOR:-vim} "$DOTFILES"'

# dots-push: add all, commit with date-stamped message, push
dots-push() {
    git -C "$DOTFILES" add -A
    git -C "$DOTFILES" commit -m "dotfiles: sync $(date '+%Y-%m-%d %H:%M')"
    git -C "$DOTFILES" push
}

# -----------------------------------------------------------------------------
# Navigation
# -----------------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# -----------------------------------------------------------------------------
# Listing
# -----------------------------------------------------------------------------
alias ll='ls -lhF'
alias la='ls -lhAF'
alias l='ls -CF'

# Use eza if available (modern ls replacement)
if command -v eza >/dev/null 2>&1; then
    alias ls='eza'
    alias ll='eza -lh --git'
    alias la='eza -lhA --git'
    alias tree='eza --tree'
fi

# -----------------------------------------------------------------------------
# Grep
# -----------------------------------------------------------------------------
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# -----------------------------------------------------------------------------
# Safety
# -----------------------------------------------------------------------------
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# -----------------------------------------------------------------------------
# Common shortcuts
# -----------------------------------------------------------------------------
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %H:%M:%S"'
