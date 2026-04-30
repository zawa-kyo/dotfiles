#!/usr/bin/env bash
# MISE_DESCRIPTION: Select a repository with ghq/fzf and open it in Neovim

set -euo pipefail

main() {
  local repo
  local script_dir

  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  repo="$("$script_dir/../utils/select-repository.sh" "$@")" || exit 1
  [ -n "$repo" ] || exit 1
  exec nvim "$repo"
}

main "$@"
