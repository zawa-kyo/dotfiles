#!/usr/bin/env bash
# MISE_DESCRIPTION: Search lines with ripgrep and open the selected result in Neovim

set -euo pipefail

main() {
  rg --no-heading --line-number --color=always '' |
    fzf \
      --ansi \
      --delimiter=: \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --bind 'enter:execute(nvim {1} +{2})'
}

main "$@"
