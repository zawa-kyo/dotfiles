#!/usr/bin/env bash

# Switch to a selected local or remote-backed branch.
run_switch_branch() {
  local mode="$1"
  local local_branch
  local ref_name

  ensure_git_and_fzf
  require_git_repository

  ref_name="$(select_branch_ref "$mode")" || return 1
  [ -n "$ref_name" ] || return 1

  local_branch="$(resolve_local_branch_name "$mode" "$ref_name")"

  case "$mode" in
  local)
    git switch -q -- "$local_branch"
    ;;
  remote)
    if git show-ref --verify --quiet "refs/heads/$local_branch"; then
      require_matching_branch_upstream "$local_branch" "$ref_name"
      git switch -q -- "$local_branch"
    else
      git switch -q -c "$local_branch" --track "$ref_name"
    fi
    ;;
  *)
    fail "unsupported switch-branch mode: $mode"
    ;;
  esac

  info "switched branch: $local_branch"
}
