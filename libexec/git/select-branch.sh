#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/fzf.sh"

# Ensure required Git and fzf commands are available.
ensure_git_and_fzf() {
  require_command git || return 1
  ensure_fzf_command
}

# Select a local or remote branch ref with fzf.
select_branch_ref() {
  local mode="$1"
  local preview_cmd='git log --oneline --decorate --color=always -20 -- {}'

  case "$mode" in
  local)
    git for-each-ref --format='%(refname:short)' refs/heads |
      run_fzf_with_preview "$preview_cmd"
    ;;
  remote)
    git for-each-ref --format='%(refname:short)' --sort=refname refs/remotes |
      awk '$0 !~ /\/HEAD$/ { print }' |
      run_fzf_with_preview "$preview_cmd"
    ;;
  *)
    printf 'unsupported branch-ref mode: %s\n' "$mode" >&2
    return 1
    ;;
  esac
}

# Resolve the local branch name for the selected ref.
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
      printf 'failed to derive local branch name from remote branch: %s\n' "$ref_name" >&2
      return 1
    fi

    printf '%s\n' "$local_branch"
    ;;
  *)
    printf 'unsupported branch-ref mode: %s\n' "$mode" >&2
    return 1
    ;;
  esac
}

# Ensure an existing local branch tracks the expected upstream ref.
require_matching_branch_upstream() {
  local local_branch="$1"
  local ref_name="$2"
  local upstream_branch

  upstream_branch="$(
    git for-each-ref --format='%(upstream:short)' "refs/heads/$local_branch"
  )"

  if [ "$upstream_branch" != "$ref_name" ]; then
    printf 'local branch already exists with different upstream: %s%s\n' \
      "$local_branch" \
      "${upstream_branch:+ -> $upstream_branch}" >&2
    return 1
  fi
}
