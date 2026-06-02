#!/usr/bin/env bash
# MISE_DESCRIPTION: Print a worktree-aware Git branch label for the Starship prompt

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
source "$script_dir/../utils/worktree-name.sh"

# Print the Git branch with a worktree-specific icon when names overlap.
main() {
  local branch
  local repo_dir_name
  local repo_root
  local suffix
  local symbol=""

  if ! repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    return 1
  fi

  branch="$(git branch --show-current 2>/dev/null || true)"
  [ -n "$branch" ] || return 1

  repo_dir_name="$(basename "$repo_root")"
  if suffix="$(worktree_suffix_from_repo_dir_name "$repo_dir_name")"; then
    if is_branch_worktree_name "$branch" "$suffix"; then
      symbol=""
    fi
  fi

  printf '%s %s\n' "$symbol" "$branch"
}

main "$@"
