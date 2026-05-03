#!/usr/bin/env bash
# MISE_DESCRIPTION: Select a local branch with fzf and add or reuse its worktree

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
source "$script_dir/../utils/log.sh"
source "$script_dir/../utils/select-branch.sh"
source "$script_dir/../utils/add-worktree.sh"

run_add_worktree local "$@"
