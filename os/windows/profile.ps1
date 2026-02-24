# =============================================================================
# profile.ps1 — PowerShell profile (Windows)
# =============================================================================

# Dotfiles location
$env:DOTFILES = "$HOME\.dotfiles"

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
Set-Alias -Name vim -Value nvim -ErrorAction SilentlyContinue
Set-Alias -Name g -Value git
Set-Alias -Name c -Value Clear-Host
Set-Alias -Name ll -Value Get-ChildItem

# -----------------------------------------------------------------------------
# Dotfiles management functions
# -----------------------------------------------------------------------------
function dots {
    Set-Location $env:DOTFILES
    git status
}

function dots-push {
    git -C $env:DOTFILES add -A
    $msg = "dotfiles: sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git -C $env:DOTFILES commit -m $msg
    git -C $env:DOTFILES push
}

function dots-pull {
    git -C $env:DOTFILES pull
}

function dots-edit {
    & $env:EDITOR $env:DOTFILES
}

# -----------------------------------------------------------------------------
# Utility functions
# -----------------------------------------------------------------------------
function mkcd {
    param([string]$Path)
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location $Path
}

function which {
    param([string]$Command)
    Get-Command $Command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
}

# -----------------------------------------------------------------------------
# Prompt — uncomment one of the following
# -----------------------------------------------------------------------------

# Starship prompt
# Invoke-Expression (&starship init powershell)

# Oh My Posh prompt
# oh-my-posh init pwsh | Invoke-Expression

# -----------------------------------------------------------------------------
# Local overrides (not committed)
# -----------------------------------------------------------------------------
$localProfile = "$HOME\.env.local.ps1"
if (Test-Path $localProfile) {
    . $localProfile
}
