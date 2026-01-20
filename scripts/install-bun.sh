#!/usr/bin/env bash

# Remove old link or directory if it exists
if [ -L "$HOME/.bun/install/global" ] || [ -d "$HOME/.bun/install/global" ]; then
  rm -rf "$HOME/.bun/install/global"
  echo "󰄳 Old Bun global directory or link removed."
fi

# Create a new symbolic link
if [ -d ~/.dotfiles/bun ]; then
  ln -s ~/.dotfiles/bun "$HOME/.bun/install/global"
  echo "󰄳 Bun directory linked successfully."
else
  echo "󰅙 Bun directory not found in dotfiles!"
  exit 1
fi

# Navigate to the Bun global directory
if cd "$HOME/.bun/install/global"; then
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
