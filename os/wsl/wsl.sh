# =============================================================================
# wsl.sh — WSL (Windows Subsystem for Linux) configuration
# =============================================================================

# DISPLAY for WSLg or X11 forwarding
if [ -n "$WSL_DISTRO_NAME" ]; then
    # WSL2 with WSLg (default in recent Windows 11)
    export DISPLAY=:0

    # For older WSL2 without WSLg, use the Windows host IP:
    # export DISPLAY="$(ip route show default | awk '{print $3}'):0"
fi

# Open Windows Explorer from current directory
alias explorer='explorer.exe .'

# Open files with the default Windows application
alias wopen='wslview'

# Access Windows home directory
export WINHOME="/mnt/c/Users/$(cmd.exe /C "echo %USERNAME%" 2>/dev/null | tr -d '\r')"

# Fix for WSL interop PATH issues
# Prevents Windows PATH from polluting Linux PATH
# Uncomment if you experience issues with Windows executables leaking into Linux:
# export PATH="$(echo "$PATH" | tr ':' '\n' | grep -v /mnt/ | tr '\n' ':')"

# Ensure SSH agent works in WSL
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" >/dev/null 2>&1
fi
