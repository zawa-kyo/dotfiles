#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$script_dir/../.." && pwd)"
source "$script_dir/../utils/dotfiles-links.sh"
source "$script_dir/../utils/log.sh"

relink() {
  local source_path="$1"
  local target_path="$2"
  local target_basename
  target_basename="$(basename "$target_path")"

  if [ ! -e "$source_path" ]; then
    fail "Source path not found: $source_path"
  fi

  if [ -L "$target_path" ]; then
    rm "$target_path" || fail "Failed to remove existing symlink: $target_path"
    info "Removed existing symlink: $target_path"
    ln -s "$source_path" "$target_path" || fail "Failed to relink $target_path"
    info "$target_basename relinked successfully."
    return 0
  fi

  if [ -e "$target_path" ]; then
    warn "$target_path exists and is not a symlink. Skipping relink."
    return 0
  fi

  local target_parent_dir
  target_parent_dir="$(dirname "$target_path")"
  if [ ! -d "$target_parent_dir" ]; then
    mkdir -p "$target_parent_dir" || fail "Failed to create directory: $target_parent_dir"
    info "Created directory: $target_parent_dir"
  fi

  ln -s "$source_path" "$target_path" || fail "Failed to link $target_path"
  info "$target_basename linked successfully."
}

populate_dotfiles_links "$dotfiles_dir"
validate_dotfiles_links "$dotfiles_dir"

for link in "${file_links[@]}"; do
  IFS=":" read -r source target <<<"$link"
  relink "$source" "$target"
done

for link in "${directory_links[@]}"; do
  IFS=":" read -r source target <<<"$link"
  relink "$source" "$target"
done

for link in "${codex_skill_links[@]}"; do
  IFS=":" read -r source target <<<"$link"
  relink "$source" "$target"
done
