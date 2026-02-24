# =============================================================================
# mac.sh — macOS-specific configuration
# =============================================================================

# Homebrew PATH (Apple Silicon and Intel)
if [ -d "/opt/homebrew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "/usr/local/Homebrew" ]; then
    eval "$(/usr/local/Homebrew/bin/brew shellenv)"
fi

# Homebrew update alias
alias brewup='brew update && brew upgrade && brew cleanup'

# Use GNU coreutils if installed via Homebrew
if command -v gls >/dev/null 2>&1; then
    alias ls='gls --color=auto'
fi

# macOS-specific aliases
alias flush-dns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'

# -----------------------------------------------------------------------------
# macOS defaults (uncomment to apply)
# Run these once manually, then comment them out
# -----------------------------------------------------------------------------
# # Show hidden files in Finder
# defaults write com.apple.finder AppleShowAllFiles -bool true
#
# # Disable press-and-hold for keys in favor of key repeat
# defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
#
# # Fast key repeat rate
# defaults write NSGlobalDomain KeyRepeat -int 2
# defaults write NSGlobalDomain InitialKeyRepeat -int 15
