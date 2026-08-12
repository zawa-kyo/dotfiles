#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$script_dir/../.." && pwd)"
bun_dir="${DIR_BUN_SOURCE:-$dotfiles_dir/config/tools/bun}"
global_dir="${DIR_BUN_GLOBAL:-$HOME/.bun/install/global}"
global_parent_dir="$(dirname "$global_dir")"
global_bin_dir="${DIR_BUN_BIN:-$HOME/.bun/bin}"

source "$script_dir/../utils/log.sh"

# Ensure the repo-managed Bun declarations exist.
ensure_bun_dir() {
  [ -d "$bun_dir" ] || fail "Bun directory not found in dotfiles: $bun_dir"
  [ -f "$bun_dir/package.json" ] || fail "Bun package manifest not found: $bun_dir/package.json"
  [ -f "$bun_dir/bun.lock" ] || fail "Bun lock file not found: $bun_dir/bun.lock"
  [ -f "$bun_dir/bunfig.toml" ] || fail "Bun config not found: $bun_dir/bunfig.toml"
}

# Replace the legacy source link with a real Bun runtime directory.
prepare_global_dir() {
  local global_real_dir
  local migrate_modules=false

  mkdir -p "$global_parent_dir" "$global_bin_dir"

  if [ -L "$global_dir" ]; then
    if ! global_real_dir="$(realpath "$global_dir" 2>/dev/null)" || [ "$global_real_dir" != "$(realpath "$bun_dir")" ]; then
      fail "Refusing to replace an unmanaged Bun symlink: $global_dir"
    fi

    rm "$global_dir"
    info "Removed legacy Bun directory symlink: $global_dir"
  elif [ -e "$global_dir" ]; then
    [ -d "$global_dir" ] || fail "Bun global path exists and is not a directory: $global_dir"
  fi

  if [ ! -d "$global_dir" ]; then
    mkdir -p "$global_dir"
    info "Created directory: $global_dir"
  fi

  if [ -L "$bun_dir/node_modules" ] && [ -e "$global_dir/node_modules" ] &&
    [ "$(realpath "$bun_dir/node_modules")" = "$(realpath "$global_dir/node_modules")" ]; then
    migrate_modules=false
  elif [ -d "$bun_dir/node_modules" ]; then
    migrate_modules=true
  fi

  if [ "$migrate_modules" = true ]; then
    if [ -e "$global_dir/node_modules" ]; then
      fail "Refusing to replace existing Bun modules: $global_dir/node_modules"
    fi
    mv "$bun_dir/node_modules" "$global_dir/node_modules"
    info "Migrated Bun modules: $global_dir/node_modules"
  fi
}

# Copy tracked declarations into the Bun runtime directory.
sync_declarations_to_runtime() {
  cp "$bun_dir/package.json" "$global_dir/package.json"
  cp "$bun_dir/bun.lock" "$global_dir/bun.lock"
  cp "$bun_dir/bunfig.toml" "$global_dir/bunfig.toml"
}

# Install dependencies from the tracked declarations.
install_dependencies() {
  bun install --cwd "$global_dir" --frozen-lockfile
  info "Bun dependencies installed successfully."
}

# Update dependencies and copy the changed declarations back to the repo.
upgrade_dependencies() {
  bun update --cwd "$global_dir" --latest
  cp "$global_dir/package.json" "$bun_dir/package.json"
  cp "$global_dir/bun.lock" "$bun_dir/bun.lock"
  info "Bun dependencies updated successfully."
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

# Run the requested Bun global setup flow.
main() {
  local mode="${1:-install}"

  ensure_bun_dir
  prepare_global_dir
  sync_declarations_to_runtime

  case "$mode" in
  install) install_dependencies ;;
  upgrade) upgrade_dependencies ;;
  *) fail "Unknown Bun setup mode: $mode" ;;
  esac

  sync_global_bins
}

main "$@"
