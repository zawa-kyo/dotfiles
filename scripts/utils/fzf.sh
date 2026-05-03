#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/require.sh"

# Print an fzf-related error and abort the current flow.
fzf_fail() {
  local message="$1"

  if command -v fail >/dev/null 2>&1; then
    fail "$message"
  else
    printf '%s\n' "$message" >&2
    return 1
  fi
}

# Ensure the fzf command is available.
ensure_fzf_command() {
  require_command fzf
}

# Run fzf with the provided options.
run_fzf() {
  ensure_fzf_command || return 1

  if [ -n "${FZF_RUN_SHELL:-}" ]; then
    SHELL="$FZF_RUN_SHELL" fzf "$@"
    return
  fi

  fzf "$@"
}

# Run fzf with a preview command.
run_fzf_with_preview() {
  local preview_cmd="$1"
  local preview_shell="${FZF_PREVIEW_SHELL:-/bin/sh}"

  shift
  ensure_fzf_command || return 1
  SHELL="$preview_shell" fzf --preview "$preview_cmd" "$@"
}
