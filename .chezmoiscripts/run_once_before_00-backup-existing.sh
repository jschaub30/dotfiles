#!/usr/bin/env bash
# First apply only: keep a copy of the files chezmoi is about to replace, and move
# existing ssh host entries into ~/.ssh/config.d/ so they keep working.
set -euo pipefail

backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
for f in .zshrc .zprofile .zshenv .gitconfig .ssh/config .config/starship.toml .config/git/ignore; do
  if [[ -e $HOME/$f || -L $HOME/$f ]]; then
    mkdir -p "$backup/$(dirname "$f")"
    cp -pP "$HOME/$f" "$backup/$f"
  fi
done
if [[ -d $backup ]]; then
  chmod -R go-rwx "$backup"
  echo "Backed up existing dotfiles to $backup"
fi

if [[ -f $HOME/.ssh/config ]] && ! grep -q 'Managed by chezmoi' "$HOME/.ssh/config"; then
  mkdir -p "$HOME/.ssh/config.d"
  if [[ ! -e $HOME/.ssh/config.d/hosts ]]; then
    cp -p "$HOME/.ssh/config" "$HOME/.ssh/config.d/hosts"
    echo "Moved existing ssh hosts to ~/.ssh/config.d/hosts"
  fi
fi
