# Dotfiles Repository — Claude Code Context

## Repo Purpose
Cross-platform dotfiles managed via symlinks, targeting macOS, Linux (generic/Debian), WSL, and Windows. The repo is always located at `~/.dotfiles`.

## How It Works
Files in `home/` are symlinked to `~/` and files/directories in `config/` are symlinked into `~/.config/` by `install.sh`. Never move or rename these files without updating `install.sh`.

## Platform Detection
`install.sh` and `.zshrc`/`.bashrc` detect the platform using:
1. `uname -s` → `Darwin` (macOS), `Linux`
2. On Linux, check `/proc/version` for `microsoft` or `Microsoft` → WSL
3. On Linux, check `/etc/debian_version` → Debian-based
4. Fallback → generic Linux

This same detection logic is used in shell configs to source the correct `os/<platform>/` script.

## Key Conventions
- All shared shell logic lives in `shared/` and is sourced by both `.zshrc` and `.bashrc`
- OS-specific overrides live in `os/<platform>/` and are sourced last
- Machine-specific or secret config goes in `~/.gitconfig-local` or `~/.env.local` — never committed
- Backup files end in `.bak` and are gitignored

## What to Never Do
- Never commit secrets, tokens, API keys, or SSH keys
- Never hardcode absolute paths — use `$DOTFILES`, `$HOME`, or `$XDG_CONFIG_HOME`
- Never break POSIX compatibility in `shared/` scripts (avoid bashisms in `aliases.sh`, `exports.sh`, `functions.sh` since they're sourced by both bash and zsh)
- Never remove the `.bak` backup logic from install scripts

## How to Add a New Dotfile
1. Place the file in `home/` (for `~/`) or `config/` (for `~/.config/`)
2. If needed, add symlink logic to `install.sh`
3. Test with `install.sh` on the relevant platform
4. Commit and push

## How to Add a Platform-Specific Config
1. Add a script to `os/<platform>/`
2. Ensure `install.sh` sources it on that platform
3. Source it in `.zshrc`/`.bashrc` platform detection block

## Sync Workflow
- Edit files directly in `~/.dotfiles` (they're already symlinked)
- Use `dots-push` to commit and push
- Use `dots-pull` on other machines

## Repo Location
The repo is always at `~/.dotfiles`. `install.sh` derives its `DOTFILES` path from its own location using `$(cd "$(dirname "$0")" && pwd)` — no cloning logic needed.

## Common Tasks
- Add new aliases or functions to `shared/`
- Add new packages to `Brewfile` or `apt-packages.txt`
- Extend `install.sh` for a new tool or config file
- Debug symlink issues
- Add a new OS target

## Testing
- Run `install.sh --dry-run` for a dry run (prints actions without executing)
- Verify symlinks with `ls -la ~/ | grep dotfiles`
