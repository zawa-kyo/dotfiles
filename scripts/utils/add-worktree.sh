#!/usr/bin/env bash

# Create or reuse a worktree for a selected local or remote-backed branch.
run_add_worktree() {
  local mode="$1"
  local existing_path
  local local_branch
  local ref_name
  local repo_base_path
  local repo_path
  local repo_root

  ensure_git_and_fzf
  require_git_repository

  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"

  ref_name="$(select_branch_ref "$mode")" || return 1
  [ -n "$ref_name" ] || return 1
  local_branch="$(resolve_local_branch_name "$mode" "$ref_name")"

  existing_path="$(
    git worktree list --porcelain |
      awk -v branch="refs/heads/$local_branch" '
        $1 == "worktree" { path = $2 }
        $1 == "branch" && $2 == branch { print path; exit }
      '
  )"
  if [ -n "$existing_path" ]; then
    warn "worktree already exists: $existing_path"
    printf '%s\n' "$existing_path"
    return 0
  fi

  repo_base_path="${repo_root%%+*}"
  repo_path="${repo_base_path}+${local_branch//\//_}"
  if [ -d "$repo_path" ]; then
    warn "directory already exists: $repo_path"
    printf '%s\n' "$repo_path"
    return 0
  fi

  case "$mode" in
  local)
    git worktree add -q -- "$repo_path" "$local_branch"
    ;;
  remote)
    if git show-ref --verify --quiet "refs/heads/$local_branch"; then
      require_matching_branch_upstream "$local_branch" "$ref_name"
      git worktree add -q -- "$repo_path" "$local_branch"
    else
      git worktree add -q -b "$local_branch" --track -- "$repo_path" "$ref_name"
    fi
    ;;
  esac

  info "created worktree: $repo_path"
  printf '%s\n' "$repo_path"
}
