#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Omarchy keeps its stock editor, terminal and shell (bash) and uses Herdr instead of tmux.
link_config() {
  local source="$1" target="$2"
  mkdir -p "$(dirname "$target")"
  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    return
  fi
  if [[ -e "$target" || -L "$target" ]]; then
    local backup="${target}.backup-$(date +%Y%m%d-%H%M%S)-$$"
    mv -- "$target" "$backup"
    echo "Backed up: $backup"
  fi
  ln -s -- "$source" "$target"
}

if [[ "$(uname -s)" == Linux ]]; then
  CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
  link_config "$DOTFILES_DIR/foot/foot.ini" "$CONFIG_DIR/foot/foot.ini"
  link_config "$DOTFILES_DIR/herdr/config.toml" "$CONFIG_DIR/herdr/config.toml"
  link_config "$DOTFILES_DIR/lazygit/config.yml" "$CONFIG_DIR/lazygit/config.yml"
  # Omarchy is bash-first: ~/.bashrc sources Omarchy's defaults, then our additions.
  link_config "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
  echo "Omarchy dotfiles setup complete (Foot, Herdr, lazygit, bash)."
  exit 0
fi

# nvim
mkdir -p ~/.config
ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim

# tmux
ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

# ghostty
mkdir -p ~/.config/ghostty
ln -sf "$DOTFILES_DIR/ghostty/config" ~/.config/ghostty/config
ln -sf "$DOTFILES_DIR/ghostty/background.conf" ~/.config/ghostty/background.conf

# lazygit
mkdir -p ~/Library/Application\ Support/lazygit
ln -sf "$DOTFILES_DIR/lazygit/config.yml" ~/Library/Application\ Support/lazygit/config.yml

# zsh (powerlevel10k)
ln -sf "$DOTFILES_DIR/zsh/.p10k.zsh" ~/.p10k.zsh

# tpm (tmux plugin manager)
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "tpm installed. Run 'prefix + I' in tmux to install plugins."
fi

echo "dotfiles setup complete!"
