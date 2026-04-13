#!/usr/bin/env bash

# Update every tool declared in mise/config.global.toml to the latest
# version reported by `mise ls-remote`.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../mise/config.global.toml"

if ! command -v mise >/dev/null 2>&1; then
  echo "󰅙 mise command not found."
  exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
  echo "󰅙 Config file not found: $CONFIG_FILE"
  exit 1
fi

tools="$(
  # Read only simple `name = "version"` entries from the [tools] section.
  awk '
    /^\[tools\]$/ { in_tools=1; next }
    /^\[/ { in_tools=0 }
    in_tools && /^[[:space:]]*[A-Za-z0-9_-]+[[:space:]]*=[[:space:]]*"[^"]*"[[:space:]]*$/ {
      line=$0
      sub(/^[[:space:]]*/, "", line)
      split(line, parts, "=")
      key=parts[1]
      sub(/[[:space:]]+$/, "", key)
      print key
    }
  ' "$CONFIG_FILE"
)"

if [ -z "$tools" ]; then
  echo "󰅙 No tools found in [tools]: $CONFIG_FILE"
  exit 1
fi

while IFS= read -r tool; do
  [ -n "$tool" ] || continue

  echo "󰄳 Resolving latest version for $tool..."
  latest_version="$(
    # `mise ls-remote` prints versions in ascending order, so use the last line.
    mise ls-remote "$tool" | awk 'NF { last=$0 } END { print last }'
  )"

  if [ -z "$latest_version" ]; then
    echo "󰅙 Failed to resolve latest version for $tool"
    exit 1
  fi

  echo "󰄳 Updating $tool to $latest_version"
  mise use -g "$tool@$latest_version"
done <<<"$tools"
