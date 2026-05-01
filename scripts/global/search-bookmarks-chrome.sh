#!/usr/bin/env bash
# MISE_DESCRIPTION: Select a Chrome bookmark with fzf and open it

set -euo pipefail

bootstrap_utils_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../utils"
if [ ! -f "$bootstrap_utils_dir/script-path.sh" ] && [ -L "${BASH_SOURCE[0]}" ]; then
  bootstrap_utils_dir="$(cd "$(dirname "$(readlink "${BASH_SOURCE[0]}")")" && pwd)/../utils"
fi
source "$bootstrap_utils_dir/script-path.sh"

script_dir="$(resolve_script_dir "${BASH_SOURCE[0]}")"
exec "$script_dir/search-bookmarks.sh" chrome "$@"
