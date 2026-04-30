#!/usr/bin/env bash
# MISE_DESCRIPTION: Select a local branch with fzf and add or reuse its worktree

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
. "$script_dir/../utils/log.sh"

main() {
  local branch
  local existing_path
  local preview_cmd='git log --oneline --decorate --color=always -20 -- {}'
  local repo_base_path
  local repo_path
  local repo_root

  command -v git >/dev/null 2>&1 || {
    warn "git is required"
    exit 1
  }

  command -v fzf >/dev/null 2>&1 || {
    warn "fzf is required"
    exit 1
  }

  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    warn "not inside a git repository"
    exit 1
  }

  branch="$(
    git for-each-ref --format='%(refname:short)' refs/heads |
      fzf --preview "$preview_cmd"
  )" || exit 1

  [ -n "$branch" ] || exit 1

  existing_path="$(
    git worktree list --porcelain |
      awk -v branch="refs/heads/$branch" '
        $1 == "worktree" { path = $2 }
        $1 == "branch" && $2 == branch { print path; exit }
      '
  )"
  if [ -n "$existing_path" ]; then
    warn "worktree already exists: $existing_path"
    printf '%s\n' "$existing_path"
    exit 0
  fi

  repo_base_path="${repo_root%%+*}"
  repo_path="${repo_base_path}+${branch//\//_}"
  if [ -d "$repo_path" ]; then
    warn "directory already exists: $repo_path"
    printf '%s\n' "$repo_path"
    exit 0
  fi

  git worktree add -q -- "$repo_path" "$branch"
  info "created worktree: $repo_path"
  printf '%s\n' "$repo_path"
}

main "$@"
