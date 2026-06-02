#!/usr/bin/env bash
# MISE_DESCRIPTION: Print a compact directory name for the Starship prompt

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
source "$script_dir/../utils/worktree-name.sh"

# Return the current directory path relative to the repository root.
relative_path_from_repo_root() {
  local repo_root="$1"
  local current_dir="$2"

  case "$current_dir" in
  "$repo_root") return 0 ;;
  "$repo_root"/*) printf '%s\n' "${current_dir#"$repo_root"/}" ;;
  *) return 0 ;;
  esac
}

# Print a directory label with redundant branch-derived worktree names folded.
main() {
  local branch
  local current_dir
  local display_root_name
  local relative_path
  local repo_dir_name
  local repo_root
  local suffix

  current_dir="$PWD"

  if ! repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    basename "$current_dir"
    return 0
  fi

  repo_dir_name="$(basename "$repo_root")"
  display_root_name="$repo_dir_name"

  branch="$(git branch --show-current 2>/dev/null || true)"
  if [ -n "$branch" ] && suffix="$(worktree_suffix_from_repo_dir_name "$repo_dir_name")"; then
    if is_branch_worktree_name "$branch" "$suffix"; then
      display_root_name="${repo_dir_name%%+*}"
    fi
  fi

  relative_path="$(relative_path_from_repo_root "$repo_root" "$current_dir")"
  if [ -n "$relative_path" ]; then
    printf '%s/%s\n' "$display_root_name" "$relative_path"
  else
    printf '%s\n' "$display_root_name"
  fi
}

main "$@"
