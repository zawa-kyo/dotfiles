#!/usr/bin/env bash

ensure_git_and_fzf() {
  command -v git >/dev/null 2>&1 || fail "git is required"
  command -v fzf >/dev/null 2>&1 || fail "fzf is required"
}

ensure_git_repository() {
  git rev-parse --show-toplevel >/dev/null 2>&1 || fail "not inside a git repository"
}

select_branch_ref() {
  local mode="$1"
  local preview_cmd='git log --oneline --decorate --color=always -20 -- {}'

  case "$mode" in
  local)
    git for-each-ref --format='%(refname:short)' refs/heads |
      SHELL=/bin/sh fzf --preview "$preview_cmd"
    ;;
  remote)
    git for-each-ref --format='%(refname:short)' --sort=refname refs/remotes |
      awk '$0 !~ /\/HEAD$/ { print }' |
      SHELL=/bin/sh fzf --preview "$preview_cmd"
    ;;
  *)
    fail "unsupported branch-ref mode: $mode"
    ;;
  esac
}

resolve_local_branch_name() {
  local mode="$1"
  local ref_name="$2"
  local local_branch

  case "$mode" in
  local)
    printf '%s\n' "$ref_name"
    ;;
  remote)
    local_branch="${ref_name#*/}"
    if [ -z "$local_branch" ] || [ "$local_branch" = "$ref_name" ]; then
      fail "failed to derive local branch name from remote branch: $ref_name"
    fi

    printf '%s\n' "$local_branch"
    ;;
  *)
    fail "unsupported branch-ref mode: $mode"
    ;;
  esac
}

require_matching_branch_upstream() {
  local local_branch="$1"
  local ref_name="$2"
  local upstream_branch

  upstream_branch="$(
    git for-each-ref --format='%(upstream:short)' "refs/heads/$local_branch"
  )"

  if [ "$upstream_branch" != "$ref_name" ]; then
    fail "local branch already exists with different upstream: $local_branch${upstream_branch:+ -> $upstream_branch}"
  fi
}
