#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$script_dir/.." && pwd)"
bun_dir="$dotfiles_dir/bun"
global_dir="$HOME/.bun/install/global"
global_parent_dir="$(dirname "$global_dir")"
global_bin_dir="$HOME/.bun/bin"

. "$script_dir/lib/log.sh"

# Ensure the repo-managed Bun directory exists.
ensure_bun_dir() {
  [ -d "$bun_dir" ] || fail "Bun directory not found in dotfiles: $bun_dir"
}

# Point Bun's global install directory at the repo-managed directory.
link_global_dir() {
  mkdir -p "$global_parent_dir" "$global_bin_dir"

  if [ -L "$global_dir" ]; then
    rm "$global_dir"
    info "Old Bun global symlink removed."
  elif [ -e "$global_dir" ]; then
    fail "$global_dir already exists and is not a symlink. Move it manually before linking."
  fi

  ln -s "$bun_dir" "$global_dir"
  info "Bun directory linked successfully."
}

# Install dependencies from the tracked Bun lockfile.
install_dependencies() {
  (
    cd "$global_dir"
    bun install --frozen-lockfile
  )
  info "Bun dependencies installed successfully."
}

# Rebuild global CLI symlinks from the managed node_modules/.bin directory.
sync_global_bins() {
  local managed_root
  local managed_bin_dir
  local existing_link
  local resolved_link
  local source_bin
  local bin_name
  local target_bin

  managed_root="$(realpath "$global_dir")"
  managed_bin_dir="$managed_root/node_modules/.bin"

  [ -d "$managed_bin_dir" ] || fail "Managed Bun bin directory not found: $managed_bin_dir"

  for existing_link in "$global_bin_dir"/*; do
    [ -L "$existing_link" ] || continue
    if ! resolved_link="$(realpath "$existing_link" 2>/dev/null)"; then
      rm "$existing_link"
      continue
    fi

    case "$resolved_link" in
      "$managed_root"/node_modules/*)
        rm "$existing_link"
        ;;
    esac
  done

  for source_bin in "$managed_bin_dir"/*; do
    [ -e "$source_bin" ] || continue
    bin_name="$(basename "$source_bin")"
    target_bin="$global_bin_dir/$bin_name"

    if [ -L "$target_bin" ]; then
      rm "$target_bin"
    elif [ -e "$target_bin" ]; then
      warn "$target_bin already exists and is not a symlink. Skipping link!"
      continue
    fi

    ln -s "$source_bin" "$target_bin"
  done

  info "Bun global binaries linked successfully."
}

# Run the full Bun global setup flow.
main() {
  ensure_bun_dir
  link_global_dir
  install_dependencies
  sync_global_bins
}

main "$@"
