#!/usr/bin/env bash
# MISE_DESCRIPTION: Select a file with fzf and open it in Neovim

set -euo pipefail

main() {
  local file

  file="$(fzf)" || exit 1
  [ -n "$file" ] || exit 1
  exec nvim "$file"
}

main "$@"
