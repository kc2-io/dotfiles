# =============================================================================
# install.ps1 — Bootstrap dotfiles for Windows (PowerShell)
#
# Usage:
#   .\install.ps1            # Install everything
#   .\install.ps1 -DryRun    # Preview actions without making changes
#
# Note: Symlinks on Windows require either:
#   - Developer Mode enabled (Settings > Update & Security > For Developers)
#   - Or running PowerShell as Administrator
# =============================================================================

param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$DOTFILES = Split-Path -Parent $MyInvocation.MyCommand.Path

# -----------------------------------------------------------------------------
# Helper functions
# -----------------------------------------------------------------------------
function Write-Info { param([string]$Msg) Write-Host "[INFO] $Msg" -ForegroundColor Blue }
function Write-Ok { param([string]$Msg) Write-Host "[OK]   $Msg" -ForegroundColor Green }
function Write-Warn { param([string]$Msg) Write-Host "[WARN] $Msg" -ForegroundColor Yellow }
function Write-Err { param([string]$Msg) Write-Host "[ERR]  $Msg" -ForegroundColor Red }

function Test-SymlinkSupport {
    $testLink = "$env:TEMP\dotfiles_symlink_test"
    $testTarget = "$env:TEMP\dotfiles_symlink_target"
    try {
        New-Item -ItemType File -Path $testTarget -Force | Out-Null
        New-Item -ItemType SymbolicLink -Path $testLink -Target $testTarget -Force | Out-Null
        Remove-Item $testLink -Force
        Remove-Item $testTarget -Force
        return $true
    } catch {
        Remove-Item $testTarget -Force -ErrorAction SilentlyContinue
        return $false
    }
}

function Backup-And-Link {
    param(
        [string]$Source,
        [string]$Destination
    )

    if ($DryRun) {
        $existing = Get-Item $Destination -ErrorAction SilentlyContinue
        if ($existing -and $existing.LinkType -eq "SymbolicLink" -and $existing.Target -eq $Source) {
            Write-Info "SKIP (already linked): $Destination -> $Source"
        } elseif (Test-Path $Destination) {
            Write-Info "WOULD backup: $Destination -> ${Destination}.bak"
            Write-Info "WOULD link:   $Destination -> $Source"
        } else {
            Write-Info "WOULD link:   $Destination -> $Source"
        }
        return
    }

    # Already correctly linked
    $existing = Get-Item $Destination -ErrorAction SilentlyContinue
    if ($existing -and $existing.LinkType -eq "SymbolicLink" -and $existing.Target -eq $Source) {
        Write-Ok "Already linked: $Destination"
        return
    }

    # Back up existing file
    if (Test-Path $Destination) {
        Write-Warn "Backing up: $Destination -> ${Destination}.bak"
        Move-Item $Destination "${Destination}.bak" -Force
    }

    # Create parent directory if needed
    $parentDir = Split-Path -Parent $Destination
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    # Create symlink
    $isDir = (Get-Item $Source).PSIsContainer
    if ($isDir) {
        New-Item -ItemType SymbolicLink -Path $Destination -Target $Source -Force | Out-Null
    } else {
        New-Item -ItemType SymbolicLink -Path $Destination -Target $Source -Force | Out-Null
    }
    Write-Ok "Linked: $Destination -> $Source"
}

# -----------------------------------------------------------------------------
# Pre-flight checks
# -----------------------------------------------------------------------------
if ($DryRun) {
    Write-Host "=== DRY RUN — no changes will be made ===" -ForegroundColor Cyan
    Write-Host ""
}

if (-not $DryRun -and -not (Test-SymlinkSupport)) {
    Write-Err "Cannot create symlinks. Please either:"
    Write-Err "  1. Enable Developer Mode in Windows Settings"
    Write-Err "  2. Run this script as Administrator"
    exit 1
}

Write-Host "============================================="
Write-Host "  Dotfiles Installer (Windows)"
Write-Host "  Source: $DOTFILES"
Write-Host "============================================="
Write-Host ""

# -----------------------------------------------------------------------------
# Symlink home/ files to ~/
# -----------------------------------------------------------------------------
Write-Info "Linking home/ files to ~/"

Get-ChildItem "$DOTFILES\home" -Force -File | ForEach-Object {
    Backup-And-Link $_.FullName "$HOME\$($_.Name)"
}

Write-Host ""

# -----------------------------------------------------------------------------
# Symlink config/ items to ~/.config/
# -----------------------------------------------------------------------------
Write-Info "Linking config/ items to ~/.config/"

if (-not $DryRun -and -not (Test-Path "$HOME\.config")) {
    New-Item -ItemType Directory -Path "$HOME\.config" -Force | Out-Null
}

Get-ChildItem "$DOTFILES\config" | ForEach-Object {
    Backup-And-Link $_.FullName "$HOME\.config\$($_.Name)"
}

Write-Host ""

# -----------------------------------------------------------------------------
# Link PowerShell profile
# -----------------------------------------------------------------------------
Write-Info "Linking PowerShell profile"

$profileSource = "$DOTFILES\os\windows\profile.ps1"
if (Test-Path $profileSource) {
    Backup-And-Link $profileSource $PROFILE
} else {
    Write-Warn "No profile.ps1 found at $profileSource"
}

Write-Host ""

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
if ($DryRun) {
    Write-Host "============================================="
    Write-Host "  Dry run complete. No changes were made."
    Write-Host "============================================="
} else {
    Write-Host "============================================="
    Write-Host "  Installation complete!"
    Write-Host "  Restart PowerShell to apply changes."
    Write-Host "============================================="
}
