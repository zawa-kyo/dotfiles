#!/usr/bin/env bash
# MISE_DESCRIPTION: Search lines with ripgrep and open the selected result in Neovim

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
source "$script_dir/../utils/fzf.sh"

main() {
  rg --no-heading --line-number --color=always '' |
    run_fzf_with_preview 'bat --color=always {1} --highlight-line {2}' \
      --ansi \
      --delimiter=: \
      --bind 'enter:execute(nvim {1} +{2})'
}

main "$@"
