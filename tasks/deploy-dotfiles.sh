#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$script_dir/.." && pwd)"
export DOTFILES_ROOT
source "$script_dir/../libexec/log.sh"
source "$script_dir/../libexec/path.sh"

action="${1:-apply}"
platform="${DOTFILES_PLATFORM:-$(uname -s | tr '[:upper:]' '[:lower:]')}"
declare -a link_types=()
declare -a link_sources=()
declare -a link_targets=()
declare -a link_platforms=()

# Register a file link from the manifest.
file_link() {
  register_link file "$@"
}

# Register a directory link from the manifest.
directory_link() {
  register_link directory "$@"
}

# Add one declarative link entry.
register_link() {
  local type="$1"
  local source="$2"
  local target="$3"
  local target_platform="$4"

  link_types+=("$type")
  link_sources+=("$source")
  link_targets+=("$target")
  link_platforms+=("$target_platform")
}

# Return success when an entry applies to the current platform.
supports_platform() {
  local target_platform="$1"

  [ "$target_platform" = all ] || [ "$target_platform" = "$platform" ]
}

# Validate the manifest before changing any files.
validate_manifest() {
  local index
  local previous
  local source
  local target
  local type

  for index in "${!link_sources[@]}"; do
    supports_platform "${link_platforms[$index]}" || continue
    source="${link_sources[$index]}"
    target="${link_targets[$index]}"
    type="${link_types[$index]}"

    case "$type" in
    file) [ -f "$source" ] || fail "Missing deployment source: $source" ;;
    directory) [ -d "$source" ] || fail "Missing deployment source: $source" ;;
    *) fail "Unknown deployment type: $type" ;;
    esac

    is_lexically_within_dir "$target" "$DOTFILES_ROOT" && fail "Deployment target is inside the repository: $target"

    for previous in "${!link_targets[@]}"; do
      [ "$previous" -lt "$index" ] || break
      supports_platform "${link_platforms[$previous]}" || continue
      [ "${link_targets[$previous]}" != "$target" ] || fail "Duplicate deployment target: $target"
    done
  done
}

# Print the change required for one entry.
show_diff() {
  local source="$1"
  local target="$2"

  if symlink_points_to "$target" "$source"; then
    return 0
  fi
  if [ -L "$target" ] && symlink_points_within_dir "$target" "$DOTFILES_ROOT"; then
    printf 'relink %s -> %s\n' "$target" "$source"
  elif [ -e "$target" ] || [ -L "$target" ]; then
    printf 'conflict %s\n' "$target"
  else
    printf 'link %s -> %s\n' "$target" "$source"
  fi
}

# Check whether one entry is already deployed.
check_link() {
  local source="$1"
  local target="$2"

  if symlink_points_to "$target" "$source"; then
    return 0
  fi
  warn "Deployment mismatch: $target"
  return 1
}

# Apply one entry without replacing user-owned paths.
apply_link() {
  local source="$1"
  local target="$2"
  local target_parent

  if symlink_points_to "$target" "$source"; then
    return 0
  fi

  target_parent="$(dirname "$target")"
  if [ -L "$target_parent" ]; then
    if ! symlink_points_within_dir "$target_parent" "$DOTFILES_ROOT"; then
      warn "Refusing to replace an unmanaged parent symlink: $target_parent"
      return 1
    fi
    rm "$target_parent"
    info "Removed managed parent symlink: $target_parent"
  elif [ -e "$target_parent" ] && [ ! -d "$target_parent" ]; then
    warn "Refusing to replace an existing parent path: $target_parent"
    return 1
  fi

  if [ -L "$target" ]; then
    if ! symlink_points_within_dir "$target" "$DOTFILES_ROOT"; then
      warn "Refusing to replace an unmanaged symlink: $target"
      return 1
    fi
    rm "$target"
    info "Removed managed symlink: $target"
  elif [ -e "$target" ]; then
    warn "Refusing to replace an existing path: $target"
    return 1
  fi

  if [ ! -d "$target_parent" ]; then
    mkdir -p "$target_parent"
    info "Created directory: $target_parent"
  fi

  ln -s "$source" "$target"
  info "Linked: $target"
}

# Run versioned migrations before applying the current manifest.
run_migrations() {
  local migration

  for migration in "$DOTFILES_ROOT/deploy/migrations/"*.sh; do
    [ -f "$migration" ] || continue
    bash "$migration" "$DOTFILES_ROOT"
  done
}

# Process every applicable manifest entry.
process_links() {
  local failures=0
  local index
  local source
  local target

  for index in "${!link_sources[@]}"; do
    supports_platform "${link_platforms[$index]}" || continue
    source="${link_sources[$index]}"
    target="${link_targets[$index]}"

    case "$action" in
    apply) apply_link "$source" "$target" || failures=$((failures + 1)) ;;
    check) check_link "$source" "$target" || failures=$((failures + 1)) ;;
    diff) show_diff "$source" "$target" ;;
    *) fail "Unknown deployment action: $action" ;;
    esac
  done

  [ "$failures" -eq 0 ] || fail "$failures deployment conflict(s) found"
}

source "$DOTFILES_ROOT/deploy/links.sh"
validate_manifest
[ "$action" != apply ] || run_migrations
process_links
