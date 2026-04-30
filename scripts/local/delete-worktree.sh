#!/usr/bin/env bash
# MISE_DESCRIPTION: Select a linked worktree with fzf and delete it after confirmation

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
. "$script_dir/../utils/log.sh"

main() {
  local confirm
  local current_path
  local preview_cmd
  local target_path

  command -v git >/dev/null 2>&1 || {
    warn "git is required"
    exit 1
  }

  command -v fzf >/dev/null 2>&1 || {
    warn "fzf is required"
    exit 1
  }

  current_path="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    warn "not inside a git repository"
    exit 1
  }

  preview_cmd='
    branch=$(git -C {} branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
      printf "branch: %s\n\n" "$branch"
    fi
    git -C {} status --short --branch 2>/dev/null
  '

  target_path="$(
    git worktree list --porcelain |
      awk -v current="$current_path" '
        $1 == "worktree" { path = $2; next }
        $1 == "branch" && path != current { print path }
      ' |
      fzf --preview "$preview_cmd"
  )" || exit 1

  [ -n "$target_path" ] || exit 1

  if [ -n "$(git -C "$target_path" status --short 2>/dev/null)" ]; then
    warn "worktree has uncommitted changes: $target_path"
    exit 1
  fi

  printf 'Remove worktree %s? [y/N]: ' "$target_path"
  read -r confirm
  case "$confirm" in
    [Yy]) ;;
    *)
      info "canceled"
      exit 1
      ;;
  esac

  git worktree remove -- "$target_path"
  info "removed worktree: $target_path"
}

main "$@"
