#!/usr/bin/env bash
# MISE_DESCRIPTION: Show CPU-heavy processes with procs

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"

exec "$script_dir/reveal-process.sh" cpu
