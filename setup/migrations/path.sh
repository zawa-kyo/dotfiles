#!/usr/bin/env bash

# Return success when the path resolves inside the directory.
is_within_dir() {
  local candidate="$1"
  local dir="$2"
  local candidate_parent
  local dir_real

  candidate_parent="$(cd "$(dirname "$candidate")" 2>/dev/null && pwd -P)/$(basename "$candidate")" || return 1
  dir_real="$(cd "$dir" 2>/dev/null && pwd -P)" || return 1

  case "$candidate_parent" in
  "$dir_real" | "$dir_real"/*) return 0 ;;
  *) return 1 ;;
  esac
}

# Return success when the absolute path is lexically inside the directory.
is_lexically_within_dir() {
  local candidate="${1%/}"
  local dir="${2%/}"

  case "$candidate" in
  "$dir" | "$dir"/*) return 0 ;;
  *) return 1 ;;
  esac
}

# Return success when the symlink target is inside the directory.
symlink_points_within_dir() {
  local candidate="$1"
  local dir="$2"
  local target

  [ -L "$candidate" ] || return 1
  target="$(readlink "$candidate")" || return 1
  case "$target" in
  /*)
    case "$target" in
    */../* | */./*) is_within_dir "$target" "$dir" ;;
    *) is_lexically_within_dir "$target" "$dir" ;;
    esac
    return
    ;;
  *) target="$(dirname "$candidate")/$target" ;;
  esac
  is_within_dir "$target" "$dir"
}

# Return success when the symlink resolves to the expected source.
symlink_points_to() {
  local candidate="$1"
  local source="$2"
  local candidate_real
  local source_real

  [ -L "$candidate" ] || return 1
  candidate_real="$(realpath "$candidate" 2>/dev/null)" || return 1
  source_real="$(realpath "$source" 2>/dev/null)" || return 1
  [ "$candidate_real" = "$source_real" ]
}
