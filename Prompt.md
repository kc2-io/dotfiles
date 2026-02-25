# Dotfiles Repo — Claude Code Prompt

Copy and paste the following prompt into Claude Code to scaffold your cross-platform dotfiles repository.

---

```
Create a cross-platform dotfiles repository using the symlink approach. Set up the full structure and all bootstrap scripts.

## Repo Structure

Create the following directory layout at the current location:

dotfiles/
├── CLAUDE.md            # Claude Code context file
├── install.sh           # Bootstrap for mac/linux/wsl
├── install.ps1          # Bootstrap for windows
├── uninstall.sh         # Remove symlinks and restore backups
├── README.md
├── home/                # Symlinked to ~/
│   ├── .zshrc
│   ├── .bashrc
│   ├── .gitconfig
│   └── .vimrc
├── config/              # Symlinked into ~/.config/
│   ├── starship.toml
│   └── nvim/
│       └── init.lua
├── os/
│   ├── mac/
│   │   └── mac.sh
│   ├── windows/
│   │   └── profile.ps1
│   ├── linux/
│   │   └── linux.sh
│   ├── debian/
│   │   └── debian.sh
│   └── wsl/
│       └── wsl.sh
├── shared/
│   ├── aliases.sh
│   ├── exports.sh
│   └── functions.sh
└── packages/
    ├── Brewfile
    ├── apt-packages.txt
    └── winget-packages.txt

## Requirements

### CLAUDE.md
Create a CLAUDE.md that gives Claude Code full context to work effectively in this repo:

- **Repo purpose**: Cross-platform dotfiles managed via symlinks, targeting macOS, Linux (generic/Debian), WSL, and Windows
- **How it works**: Files in home/ and config/ are symlinked to their target locations by install.sh. Never move or rename these files without updating install.sh
- **Platform detection**: Explain the detection logic used in install.sh and .zshrc so Claude understands how platform-specific code flows
- **Key conventions**:
  - All shared shell logic lives in shared/ and is sourced by both .zshrc and .bashrc
  - OS-specific overrides live in os/<platform>/ and are sourced last
  - Machine-specific or secret config goes in ~/.gitconfig-local or ~/.env.local — never committed
  - Backup files end in .bak and are gitignored
- **What to never do**:
  - Never commit secrets, tokens, API keys, or SSH keys
  - Never hardcode absolute paths — use $DOTFILES, $HOME, or $XDG_CONFIG_HOME
  - Never break POSIX compatibility in shared/ scripts (avoid bashisms in aliases.sh, exports.sh, functions.sh since they're sourced by both bash and zsh)
  - Never remove the .bak backup logic from install scripts
- **How to add a new dotfile**: Step-by-step instructions — add file to home/ or config/, add symlink logic to install.sh if needed, test with install.sh on relevant platform, commit and push
- **How to add a platform-specific config**: Add a script to os/<platform>/, ensure install.sh sources it on that platform, source it in .zshrc/.bashrc
- **Sync workflow**: Edit files directly in ~/.dotfiles (they're already symlinked), use `dots-push` to commit and push, use `dots-pull` on other machines
- **Repo location assumption**: The repo is always located at ~/.dotfiles. The install.sh script derives its DOTFILES path from its own location using `$(cd "$(dirname "$0")" && pwd)` — no cloning logic needed
- **Common tasks Claude might be asked to do in this repo**:
  - Add new aliases or functions to shared/
  - Add new packages to Brewfile or apt-packages.txt
  - Extend install.sh for a new tool or config file
  - Debug symlink issues
  - Add a new OS target
- **Testing**: How to do a dry run of install.sh (suggest a --dry-run flag to implement), and how to verify symlinks with ls -la ~/ | grep dotfiles

### install.sh
- Detect if running on Mac, Linux (generic), Debian-based, or WSL
- Assume the repo already exists at ~/.dotfiles (the script lives inside the repo itself)
- Back up any existing files by renaming them to filename.bak before symlinking
- Symlink all files in home/ to ~/
- Symlink all directories/files in config/ to ~/.config/
- Run the appropriate os/ setup script for the detected platform
- Print clear status messages for each action
- Be idempotent — safe to run multiple times

### install.ps1
- Symlink home/ files to ~/
- Symlink config/ items to ~/.config/ (create dir if needed)
- Symlink os/windows/profile.ps1 to $PROFILE
- Handle the case where symlinks require admin or Developer Mode
- Be idempotent

### uninstall.sh
- Remove all symlinks created by install.sh
- Restore any .bak files back to their original names
- Print status for each action

### home/.zshrc
- Set DOTFILES env var pointing to ~/.dotfiles
- Source shared/aliases.sh, shared/exports.sh, shared/functions.sh
- Detect platform and source the appropriate os/ script
- Leave commented placeholders for PATH additions and tool inits (nvm, pyenv, etc.)

### home/.bashrc
- Same structure as .zshrc but for bash

### home/.gitconfig
- Include sensible defaults: pull.rebase = true, init.defaultBranch = main, core.autocrlf = input
- Include an [includeIf] block for a local gitconfig override at ~/.gitconfig-local (gitignored)
- Leave a commented example for work vs personal identity switching

### shared/aliases.sh
- dots — cd to $DOTFILES and show git status
- dots-push — add all, commit with date-stamped message, push
- dots-pull — pull latest
- dots-edit — open $DOTFILES in $EDITOR
- Common utility aliases: ll, la, ..., grep with color, etc.

### shared/exports.sh
- Set DOTFILES=~/.dotfiles
- Set sensible EDITOR, HISTSIZE, HISTFILESIZE defaults
- Add ~/.local/bin to PATH

### shared/functions.sh
- mkcd — mkdir and cd in one command
- extract — universal archive extractor (tar, zip, gz, etc.)
- A placeholder for any custom functions

### os/mac/mac.sh
- Set Mac-specific PATH additions (Homebrew, etc.)
- brewup alias for updating everything
- Placeholder for macOS defaults commands

### os/wsl/wsl.sh
- Set DISPLAY for WSLg or X11 forwarding
- Alias to open Windows Explorer from current directory
- Fix for WSL interop path issues if needed

### os/linux/linux.sh and os/debian/debian.sh
- Minimal stubs with a comment explaining where to add distro-specific config

### os/windows/profile.ps1
- Set common PowerShell aliases and prompt customizations
- Equivalent dots / dots-push / dots-pull functions for PowerShell
- Placeholder for Oh My Posh or Starship init

### packages/Brewfile
- Include: git, zsh, neovim, starship, fzf, ripgrep, bat, eza, zoxide

### packages/apt-packages.txt
- Same tools where available via apt: git, zsh, neovim, fzf, ripgrep, bat

### packages/winget-packages.txt
- Equivalent winget package IDs for the same tools

### README.md
- Bootstrap instructions for each platform: clone the repo to ~/.dotfiles, then run install.sh (or install.ps1 on Windows)
- Explanation of the repo structure
- How the sync workflow works (edit in ~/.dotfiles, commit, pull on other machines)
- Note about ~/.gitconfig-local for machine-specific overrides and secrets

## Additional Notes
- Add a .gitignore that excludes *.bak, .env.local, and any OS clutter (.DS_Store, Thumbs.db)
- All shell scripts should have proper shebangs and be chmod +x
- Scripts should use set -e and handle errors gracefully
- Keep comments in all config files explaining what each section does
```
