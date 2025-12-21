#!/usr/bin/env bash

# install: create a symlink from source to target if safe.
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
      echo "󰅙 $source_basename not found in dotfiles!"
      exit 1
    fi
  elif [ "$type" = "dir" ]; then
    if [ ! -d "$source_file" ]; then
      echo "󰅙 $source_basename directory not found in dotfiles!"
      exit 1
    fi
  else
    echo "󰅙 Invalid type: $type. Use 'file' or 'dir'."
    exit 1
  fi

  # Create target parent directory if it doesn't exist
  local target_parent_dir
  target_parent_dir="$(dirname "$target_file")"
  if [ ! -d "$target_parent_dir" ]; then
    if mkdir -p "$target_parent_dir"; then
      echo "󰄳 Created directory: $target_parent_dir"
    else
      echo "󰅙 Failed to create directory: $target_parent_dir"
      exit 1
    fi
  fi

  # Check if target already exists
  if [ -e "$target_file" ] || [ -L "$target_file" ]; then
    if [ -L "$target_file" ]; then
      local existing_target
      existing_target="$(readlink "$target_file")"
      if [ "$existing_target" = "$source_file" ]; then
        echo "󰄳 $source_basename already linked."
        return 0
      fi
      echo "󰅙 $target_file points to a different source ($existing_target)."
      exit 1
    fi
    echo "󰅙 $target_file already exists and is not a symlink! Skipping link!"
    return 0
  fi

  # Create symbolic link
  if ln -s "$source_file" "$target_file"; then
    echo "󰄳 $source_basename linked successfully."
  else
    echo "󰅙 Failed to link $source_basename!"
    exit 1
  fi
}

# install_file: create a file symlink.
install_file() {
  local source_file="$1"
  local target_file="$2"
  install "$source_file" "$target_file" "file"
}

# install_dir: create a directory symlink.
install_dir() {
  local source_dir="$1"
  local target_dir="$2"
  install "$source_dir" "$target_dir" "dir"
}

file_links=(
  "$HOME/.dotfiles/terminal/.zlogin:$HOME/.zlogin"
  "$HOME/.dotfiles/terminal/.zlogout:$HOME/.zlogout"
  "$HOME/.dotfiles/terminal/.zprofile:$HOME/.zprofile"
  "$HOME/.dotfiles/terminal/.zshenv:$HOME/.zshenv"
  "$HOME/.dotfiles/terminal/.zshrc:$HOME/.zshrc"
  "$HOME/.dotfiles/borders/bordersrc:$HOME/.config/borders/bordersrc"
  "$HOME/.dotfiles/ghostty/config:$HOME/.config/ghostty/config"
  "$HOME/.dotfiles/mise/config.global.toml:$HOME/.config/mise/config.toml"
  "$HOME/.dotfiles/sheldon/abbreviations:$HOME/.config/zsh-abbr/user-abbreviations"
  "$HOME/.dotfiles/sheldon/plugins.toml:$HOME/.config/sheldon/plugins.toml"
  "$HOME/.dotfiles/starship.toml:$HOME/.config/starship.toml"
  "$HOME/.dotfiles/zellij/config.kdl:$HOME/.config/zellij/config.kdl"
)

directory_links=(
  "$HOME/.dotfiles/nvim:$HOME/.config/nvim"
  "$HOME/.dotfiles/wezterm:$HOME/.config/wezterm"
)

# Link listed files from dotfiles into their target locations.
for link in "${file_links[@]}"; do
  IFS=":" read -r source target <<<"$link"
  install_file "$source" "$target"
done

# Link listed directories from dotfiles into their target locations.
for link in "${directory_links[@]}"; do
  IFS=":" read -r source target <<<"$link"
  install_dir "$source" "$target"
done
