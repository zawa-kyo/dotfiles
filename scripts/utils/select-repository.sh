#!/usr/bin/env bash

set -euo pipefail

select_repository() {
  local query="${*:-}"
  local preview_cmd
  local -a fzf_opts

  preview_cmd='
    git_status=$(git -C {} status --short 2>/dev/null)
    if [ -n "$git_status" ]; then
      printf "%s\n\n" "$git_status"
    fi
    eza --tree --level=2 --git-ignore --color=always --icons {}
  '

  fzf_opts=(--preview "$preview_cmd")
  if [ -n "$query" ]; then
    fzf_opts+=(--query "$query")
  fi

  ghq list --full-path | SHELL=/bin/sh fzf "${fzf_opts[@]}"
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

  matches="$(ghq list --full-path | SHELL=/bin/sh fzf --filter="$query" || true)"
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
