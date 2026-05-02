#!/usr/bin/env bash
# MISE_DESCRIPTION: Select a repository with ghq/fzf and open it in Neovim

set -euo pipefail

main() {
  local repo
  local script_path
  local script_dir

  script_path="$(realpath "${BASH_SOURCE[0]}")"
  script_dir="$(cd "$(dirname "$script_path")" && pwd)"
  repo="$("$script_dir/../utils/select-repository.sh" "$@")" || exit 1
  [ -n "$repo" ] || exit 1
  cd "$repo" || exit 1
  exec nvim .
}

main "$@"
