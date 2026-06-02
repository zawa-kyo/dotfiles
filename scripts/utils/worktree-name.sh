#!/usr/bin/env bash

# Return the worktree directory suffix for a branch name.
worktree_suffix_for_branch() {
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

  [ "$worktree_name" = "$(worktree_suffix_for_branch "$branch")" ]
}

# Return the repository base path used before +worktree-suffix.
worktree_base_path_for_repo_root() {
  local repo_root="$1"

  printf '%s\n' "${repo_root%%+*}"
}

# Return the managed worktree path for a repo root and local branch.
worktree_path_for_branch() {
  local repo_root="$1"
  local local_branch="$2"
  local repo_base_path

  repo_base_path="$(worktree_base_path_for_repo_root "$repo_root")"
  printf '%s+%s\n' "$repo_base_path" "$(worktree_suffix_for_branch "$local_branch")"
}
