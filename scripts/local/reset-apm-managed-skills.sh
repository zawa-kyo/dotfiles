#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/../utils/log.sh"

# Temporary workaround for APM 0.16.0 refusing to delete stale skill directories.
# Treat these paths as generated artifacts owned entirely by config/ai/apm/apm.lock.yaml.
reset_apm_managed_path() {
  local path="$1"

  if [ ! -e "$path" ] && [ ! -L "$path" ]; then
    return 0
  fi

  rm -rf "$path"
  info "Removed APM-managed path: $path"
}

reset_apm_managed_path "${DIR_AGENT_SKILLS:-$HOME/.agents/skills}"
reset_apm_managed_path "${DIR_CLAUDE_SKILLS:-$HOME/.claude/skills}"
reset_apm_managed_path "${DIR_APM_MODULES:-$HOME/.apm/apm_modules}"
