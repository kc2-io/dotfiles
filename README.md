# Dotfiles

Cross-platform dotfiles managed via symlinks, targeting macOS, Linux (generic/Debian), WSL, and Windows.

## Quick Start

### macOS / Linux / WSL

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh uninstall.sh
./install.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/YOUR_USERNAME/dotfiles.git $HOME\.dotfiles
cd $HOME\.dotfiles
.\install.ps1
```

> **Note:** On Windows, symlinks require Developer Mode enabled or an elevated (Administrator) PowerShell prompt.

## Repo Structure

```
dotfiles/
├── CLAUDE.md            # Claude Code context file
├── install.sh           # Bootstrap for macOS/Linux/WSL
├── install.ps1          # Bootstrap for Windows
├── uninstall.sh         # Remove symlinks and restore backups
├── home/                # Symlinked to ~/
│   ├── .zshrc
│   ├── .bashrc
│   ├── .gitconfig
│   └── .vimrc
├── config/              # Symlinked into ~/.config/
│   ├── starship.toml
│   └── nvim/
│       └── init.lua
├── os/                  # Platform-specific configs
│   ├── mac/mac.sh
│   ├── linux/linux.sh
│   ├── debian/debian.sh
│   ├── wsl/wsl.sh
│   └── windows/profile.ps1
├── shared/              # Shell config sourced by .zshrc and .bashrc
│   ├── aliases.sh
│   ├── exports.sh
│   └── functions.sh
└── packages/            # Package lists per platform
    ├── Brewfile
    ├── apt-packages.txt
    └── winget-packages.txt
```

## How It Works

1. `install.sh` (or `install.ps1`) detects your platform
2. Files in `home/` are symlinked to `~/` (e.g., `home/.zshrc` → `~/.zshrc`)
3. Files/directories in `config/` are symlinked into `~/.config/`
4. The appropriate `os/<platform>/` script is sourced
5. Existing files are backed up as `filename.bak` before being replaced

## Sync Workflow

Since your dotfiles are symlinked, editing `~/.zshrc` edits the repo file directly.

```bash
# Quick sync from any directory
dots-push    # add all, commit with timestamp, push
dots-pull    # pull latest on another machine
dots         # cd to dotfiles repo, show status
dots-edit    # open dotfiles in your $EDITOR
```

## Machine-Specific Overrides

For settings that shouldn't be committed (work email, API tokens, etc.):

- **Git identity:** Create `~/.gitconfig-local` — it's automatically included via `[include]` in `.gitconfig`
- **Shell environment:** Create `~/.env.local` — it's sourced at the end of `.zshrc` / `.bashrc`

## Dry Run

Preview what the installer will do without making changes:

```bash
./install.sh --dry-run
```

## Uninstall

Remove all symlinks and restore backed-up files:

```bash
./uninstall.sh
```

## Adding a New Dotfile

1. Place the file in `home/` (for `~/`) or `config/` (for `~/.config/`)
2. Run `./install.sh` — it automatically picks up new files
3. Commit and push

## Adding a Platform-Specific Config

1. Add a script to `os/<platform>/`
2. Ensure it's sourced in the platform detection block of `.zshrc`/`.bashrc`
3. Commit and push
