#!/usr/bin/env bash

install() {
  local source_file="$1"
  local target_file="$2"
  local type="$3"

  # Extract the base name (e.g., config.toml from /path/to/config.toml)
  local source_basename
  source_basename="$(basename "$source_file")"

  # Check if source exists
  if [ "$type" = "file" ]; then
    if [ ! -f "$source_file" ]; then
      echo "❌ $source_basename not found in dotfiles!"
      exit 1
    fi
  elif [ "$type" = "dir" ]; then
    if [ ! -d "$source_file" ]; then
      echo "❌ $source_basename directory not found in dotfiles!"
      exit 1
    fi
  else
    echo "❌ Invalid type: $type. Use 'file' or 'dir'."
    exit 1
  fi

  # Create target parent directory if it doesn't exist
  local target_parent_dir
  target_parent_dir="$(dirname "$target_file")"
  if [ ! -d "$target_parent_dir" ]; then
    mkdir -p "$target_parent_dir"
    if [ $? -eq 0 ]; then
      echo "✅ Created directory: $target_parent_dir"
    else
      echo "❌ Failed to create directory: $target_parent_dir"
      exit 1
    fi
  fi

  # Check if target already exists
  if [ -e "$target_file" ]; then
    echo "❌ $target_file already exists! Skipping link!"
  else
    # Create symbolic link
    ln -s "$source_file" "$target_file"
    if [ $? -eq 0 ]; then
      echo "✅ $source_basename linked successfully."
    else
      echo "❌ Failed to link $source_basename!"
      exit 1
    fi
  fi
}

install_file() {
  local source_file="$1"
  local target_file="$2"
  install "$source_file" "$target_file" "file"
}

install_dir() {
  local source_dir="$1"
  local target_dir="$2"
  install "$source_dir" "$target_dir" "dir"
}

install_file "$HOME/.dotfiles/terminal/.zshrc" "$HOME/.zshrc"
install_file "$HOME/.dotfiles/terminal/.zshenv" "$HOME/.zshenv"
install_file "$HOME/.dotfiles/terminal/.zprofile" "$HOME/.zprofile"
install_file "$HOME/.dotfiles/terminal/.zlogin" "$HOME/.zlogin"
install_file "$HOME/.dotfiles/terminal/.zlogout" "$HOME/.zlogout"

install_file "$HOME/.dotfiles/mise/config.toml" "$HOME/.config/mise/config.toml"
install_file "$HOME/.dotfiles/starship.toml" "$HOME/.config/starship.toml"

install_dir "$HOME/.dotfiles/nvim" "$HOME/.config/nvim"
install_dir "$HOME/.dotfiles/wezterm" "$HOME/.config/wezterm"
