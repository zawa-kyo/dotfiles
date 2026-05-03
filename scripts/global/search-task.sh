#!/usr/bin/env bash
# MISE_DESCRIPTION: Select a global mise task with fzf and run it

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
source "$script_dir/../utils/fzf.sh"

main() {
  local selected
  local task_name

  selected="$(
    mise tasks ls --global 2>/dev/null |
      run_fzf --prompt='mise task> '
  )" || exit 1

  [ -n "$selected" ] || exit 1

  task_name="${selected%%[[:space:]]*}"
  [ -n "$task_name" ] || exit 1

  exec mise run "$task_name"
}

main "$@"
