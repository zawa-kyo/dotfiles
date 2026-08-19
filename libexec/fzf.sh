#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/require.sh"

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
