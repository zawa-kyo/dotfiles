#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$script_dir/.." && pwd)"
bun_dir="$dotfiles_dir/bun"
target_dir="$HOME/.bun/install/global"

if [ ! -d "$bun_dir" ]; then
  echo "󰅙 Bun directory not found in dotfiles!"
  exit 1
fi

# Remove old link or directory if it exists
if [ -L "$target_dir" ]; then
  rm "$target_dir"
  echo "󰄳 Old Bun global symlink removed."
elif [ -d "$target_dir" ]; then
  echo "󰅙 $target_dir already exists as a directory. Move it manually before linking."
  exit 1
fi

# Create a new symbolic link
ln -s "$bun_dir" "$target_dir"
echo "󰄳 Bun directory linked successfully."

# Navigate to the Bun global directory
if cd "$target_dir"; then
  echo "󰄳 Moved to Bun global directory."
else
  echo "󰅙 Failed to move to Bun global directory."
  exit 1
fi

# Install dependencies
if bun install; then
  echo "󰄳 Bun dependencies installed successfully."
else
  echo "󰅙 Failed to install Bun dependencies."
  exit 1
fi
