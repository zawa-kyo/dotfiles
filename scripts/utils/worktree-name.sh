#!/usr/bin/env bash

# Return the Worktrunk directory suffix for a branch name.
worktree_suffix_for_branch() {
  local branch="$1"

  printf '%s\n' "${branch//\//-}"
}

# Return the legacy directory suffix used before Worktrunk.
legacy_worktree_suffix_for_branch() {
  local branch="$1"

  printf '%s\n' "${branch//\//_}"
}

# Return the suffix after the first + in a worktree repository directory name.
worktree_suffix_from_repo_dir_name() {
  local repo_dir_name="$1"

  case "$repo_dir_name" in
  *+*) printf '%s\n' "${repo_dir_name#*+}" ;;
  *) return 1 ;;
  esac
}

# Return success when a worktree directory name matches the branch-derived name.
is_branch_worktree_name() {
  local branch="$1"
  local worktree_name="$2"

  [ "$worktree_name" = "$(worktree_suffix_for_branch "$branch")" ] ||
    [ "$worktree_name" = "$(legacy_worktree_suffix_for_branch "$branch")" ]
}
