#!/usr/bin/env bash

run_add_worktree() {
  local mode="$1"
  local existing_path
  local local_branch
  local preview_cmd='git log --oneline --decorate --color=always -20 -- {}'
  local ref_name
  local repo_base_path
  local repo_path
  local repo_root
  local upstream_branch

  command -v git >/dev/null 2>&1 || fail "git is required"
  command -v fzf >/dev/null 2>&1 || fail "fzf is required"

  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || fail "not inside a git repository"

  case "$mode" in
  local)
    ref_name="$(
      git for-each-ref --format='%(refname:short)' refs/heads |
        SHELL=/bin/sh fzf --preview "$preview_cmd"
    )" || return 1
    [ -n "$ref_name" ] || return 1
    local_branch="$ref_name"
    ;;
  remote)
    ref_name="$(
      git for-each-ref --format='%(refname:short)' --sort=refname refs/remotes |
        awk '$0 !~ /\/HEAD$/ { print }' |
        SHELL=/bin/sh fzf --preview "$preview_cmd"
    )" || return 1
    [ -n "$ref_name" ] || return 1

    local_branch="${ref_name#*/}"
    if [ -z "$local_branch" ] || [ "$local_branch" = "$ref_name" ]; then
      fail "failed to derive local branch name from remote branch: $ref_name"
    fi
    ;;
  *)
    fail "unsupported add-worktree mode: $mode"
    ;;
  esac

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
      upstream_branch="$(
        git for-each-ref --format='%(upstream:short)' "refs/heads/$local_branch"
      )"

      if [ "$upstream_branch" != "$ref_name" ]; then
        fail "local branch already exists with different upstream: $local_branch${upstream_branch:+ -> $upstream_branch}"
      fi

      git worktree add -q -- "$repo_path" "$local_branch"
    else
      git worktree add -q -b "$local_branch" --track -- "$repo_path" "$ref_name"
    fi
    ;;
  esac

  info "created worktree: $repo_path"
  printf '%s\n' "$repo_path"
}
