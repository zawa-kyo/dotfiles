#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/fzf.sh"

select_repository() {
  local query="${*:-}"
  local preview_cmd

  preview_cmd='
    git_status=$(git -C {} status --short 2>/dev/null)
    if [ -n "$git_status" ]; then
      printf "%s\n\n" "$git_status"
    fi
    eza --tree --level=2 --git-ignore --color=always --icons {}
  '

  if [ -n "$query" ]; then
    ghq list --full-path | run_fzf_with_preview "$preview_cmd" --query "$query"
    return
  fi

  ghq list --full-path | run_fzf_with_preview "$preview_cmd"
}

find_repository() {
  local repo
  local ghq_root
  local query="${*:-}"
  local matches=""
  local matched_count=0
  local matched_repo=""

  if [ "$#" -eq 0 ]; then
    select_repository
    return
  fi

  ghq_root="$(ghq root)"
  repo="$(zoxide query --base-dir "$ghq_root" "$@" 2>/dev/null || true)"
  if [ -n "$repo" ]; then
    printf '%s\n' "$repo"
    return 0
  fi

  matches="$(ghq list --full-path | run_fzf --filter="$query" || true)"
  if [ -n "$matches" ]; then
    while IFS= read -r repo; do
      [ -n "$repo" ] || continue
      matched_count=$((matched_count + 1))
      matched_repo="$repo"
    done <<EOF
$matches
EOF
    if [ "$matched_count" -eq 1 ]; then
      printf '%s\n' "$matched_repo"
      return 0
    fi
  fi

  select_repository "$@"
}

main() {
  find_repository "$@"
}

main "$@"
