#!/usr/bin/env bash

# Print a requirement error and abort the current flow.
require_fail() {
  local message="$1"

  if command -v fail >/dev/null 2>&1; then
    fail "$message"
  else
    printf '%s\n' "$message" >&2
    return 1
  fi
}

# Ensure the given command is available.
require_command() {
  local command_name="$1"

  command -v "$command_name" >/dev/null 2>&1 || require_fail "$command_name is required"
}

# Ensure the given regular file exists.
require_file() {
  local file_path="$1"
  local message="${2:-file not found: $file_path}"

  [ -f "$file_path" ] || require_fail "$message"
}

# Ensure the current directory is inside a Git repository.
require_git_repository() {
  git rev-parse --show-toplevel >/dev/null 2>&1 || require_fail "not inside a git repository"
}
