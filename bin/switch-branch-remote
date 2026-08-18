#!/usr/bin/env bash
# DESCRIPTION: Select a remote branch with fzf and switch to its local tracking branch

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
source "$script_dir/../libexec/log.sh"
source "$script_dir/../libexec/select-branch.sh"
source "$script_dir/../libexec/switch-branch.sh"

run_switch_branch remote "$@"
