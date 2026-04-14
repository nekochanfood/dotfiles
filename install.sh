#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$DOTFILES_DIR/$1"
  local dst="$HOME/$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "Backing up $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "Linked $dst -> $src"
}

link ".zshrc"          ".zshrc"
link ".tmux.conf"      ".tmux.conf"
link "config/nvim"     ".config/nvim"

echo "Done!"
echo ""
echo "Note: For Windows, use install.ps1 instead (neovim only)."
