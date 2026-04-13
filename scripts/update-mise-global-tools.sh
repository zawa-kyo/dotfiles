#!/usr/bin/env bash

# Update every tool declared in mise/config.global.toml to the latest
# version reported by `mise ls-remote`.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../mise/config.global.toml"

list_tools() {
  # Read only simple `name = "version"` entries from the [tools] section.
  # Output format: <tool>\t<current_version>
  awk '
    /^\[tools\]$/ { in_tools=1; next }
    /^\[/ { in_tools=0 }
    in_tools && /^[[:space:]]*[A-Za-z0-9_-]+[[:space:]]*=[[:space:]]*"[^"]*"[[:space:]]*$/ {
      line=$0
      sub(/^[[:space:]]*/, "", line)
      split(line, parts, "=")
      key=parts[1]
      value=parts[2]
      sub(/[[:space:]]+$/, "", key)
      gsub(/^[[:space:]]*"/, "", value)
      gsub(/"[[:space:]]*$/, "", value)
      print key "\t" value
    }
  ' "$CONFIG_FILE"
}

latest_version_for() {
  local tool="$1"

  # `mise ls-remote` prints versions in ascending order, so use the last line.
  mise ls-remote "$tool" | awk 'NF { last=$0 } END { print last }'
}

main() {
  local tools
  local tool
  local current_version
  local latest_version

  if ! command -v mise >/dev/null 2>&1; then
    echo "󰅙 mise command not found."
    exit 1
  fi

  if [ ! -f "$CONFIG_FILE" ]; then
    echo "󰅙 Config file not found: $CONFIG_FILE"
    exit 1
  fi

  tools="$(list_tools)"

  if [ -z "$tools" ]; then
    echo "󰅙 No tools found in [tools]: $CONFIG_FILE"
    exit 1
  fi

  while IFS=$'\t' read -r tool current_version; do
    [ -n "$tool" ] || continue

    echo "󰄳 Resolving latest version for $tool..."
    latest_version="$(latest_version_for "$tool")"

    if [ -z "$latest_version" ]; then
      echo "󰅙 Failed to resolve latest version for $tool"
      exit 1
    fi

    if [ "$latest_version" = "$current_version" ]; then
      echo "󰄳 $tool is already up to date ($current_version)"
      continue
    fi

    echo "󰄳 Updating $tool to $latest_version"
    mise use -g "$tool@$latest_version"
  done <<<"$tools"
}

main "$@"
