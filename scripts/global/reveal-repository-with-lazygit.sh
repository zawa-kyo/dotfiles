#!/usr/bin/env bash
# MISE_DESCRIPTION: Select a repository with ghq/fzf and open it in lazygit

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
repo="$("$script_dir/../utils/select-repository.sh" "$@")" || exit 1
[ -n "$repo" ] || exit 1
exec lazygit -p "$repo"
