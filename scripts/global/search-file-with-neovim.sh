#!/usr/bin/env bash
# MISE_DESCRIPTION: Select a file with fzf and open it in Neovim

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
source "$script_dir/../utils/fzf.sh"

main() {
  local file

  file="$(
    run_fzf_with_preview 'bat --style=numbers --color=always {}'
  )" || exit 1
  [ -n "$file" ] || exit 1
  exec nvim "$file"
}

main "$@"
