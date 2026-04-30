#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$script_dir/.." && pwd)"
. "$script_dir/utils/dotfiles-links.sh"
. "$script_dir/utils/log.sh"

# Print the canonical absolute path for a file or directory.
resolve_path() {
  realpath "$1"
}

# Create a symlink from source to target if safe.
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
      fail "$source_basename not found in dotfiles!"
    fi
  elif [ "$type" = "dir" ]; then
    if [ ! -d "$source_file" ]; then
      fail "$source_basename directory not found in dotfiles!"
    fi
  else
    fail "Invalid type: $type. Use 'file' or 'dir'."
  fi

  # Create target parent directory if it doesn't exist
  local target_parent_dir
  target_parent_dir="$(dirname "$target_file")"
  if [ ! -d "$target_parent_dir" ]; then
    if mkdir -p "$target_parent_dir"; then
      info "Created directory: $target_parent_dir"
    else
      fail "Failed to create directory: $target_parent_dir"
    fi
  fi

  # Check if target already exists
  if [ -e "$target_file" ] || [ -L "$target_file" ]; then
    if [ -L "$target_file" ]; then
      local existing_target
      existing_target="$(readlink "$target_file")"
      if [ "$(resolve_path "$target_file")" = "$(resolve_path "$source_file")" ]; then
        info "$source_basename already linked."
        return 0
      fi
      if [ ! -e "$(dirname "$target_file")/$existing_target" ] && [ ! -e "$existing_target" ]; then
        rm "$target_file"
        info "Removed stale symlink: $target_file"
      else
        fail "$target_file points to a different source ($existing_target)."
      fi
    fi
    if [ -e "$target_file" ] || [ -L "$target_file" ]; then
      warn "$target_file already exists and is not a symlink! Skipping link!"
      return 0
    fi
  fi

  # Create symbolic link
  if ln -s "$source_file" "$target_file"; then
    info "$source_basename linked successfully."
  else
    fail "Failed to link $source_basename!"
  fi
}

# Create a file symlink.
install_file() {
  local source_file="$1"
  local target_file="$2"
  install "$source_file" "$target_file" "file"
}

# Create a directory symlink.
install_dir() {
  local source_dir="$1"
  local target_dir="$2"
  install "$source_dir" "$target_dir" "dir"
}

populate_dotfiles_links "$dotfiles_dir"

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
