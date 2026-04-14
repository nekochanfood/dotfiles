#Requires -Version 5.1
<#
.SYNOPSIS
    Windows dotfiles installer
.DESCRIPTION
    Sets up neovim config by creating a junction from %LOCALAPPDATA%\nvim
    to the dotfiles config/nvim directory.
    Run from the dotfiles directory:
        powershell -ExecutionPolicy Bypass -File install.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DotfilesDir = $PSScriptRoot

function Link-Dir {
    param(
        [string]$Src,
        [string]$Dst
    )

    if (Test-Path $Dst) {
        $item = Get-Item $Dst -Force
        if ($item.LinkType -eq "Junction" -or $item.LinkType -eq "SymbolicLink") {
            Write-Host "Already linked: $Dst"
            return
        } else {
            $backup = "$Dst.bak"
            Write-Host "Backing up $Dst -> $backup"
            Move-Item -Path $Dst -Destination $backup -Force
        }
    }

    $parent = Split-Path $Dst -Parent
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    New-Item -ItemType Junction -Path $Dst -Target $Src | Out-Null
    Write-Host "Linked $Dst -> $Src"
}

# neovim: %LOCALAPPDATA%\nvim -> dotfiles/config/nvim
$nvimSrc = Join-Path $DotfilesDir "config\nvim"
$nvimDst = Join-Path $env:LOCALAPPDATA "nvim"
Link-Dir -Src $nvimSrc -Dst $nvimDst

Write-Host ""
Write-Host "Done!"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Install Neovim: winget install Neovim.Neovim"
Write-Host "  2. Install a Nerd Font (for icons): https://www.nerdfonts.com/"
Write-Host "  3. Install git: winget install Git.Git"
Write-Host "  4. Open nvim - lazy.nvim will auto-install plugins on first launch"
