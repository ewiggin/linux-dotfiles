#!/usr/bin/env bash
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  [[ -e "$dst" && ! -L "$dst" ]] && mv "$dst" "$dst.bak" && echo "Backup: $dst.bak"
  ln -sf "$src" "$dst"
  echo "✓ $dst"
}

symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
