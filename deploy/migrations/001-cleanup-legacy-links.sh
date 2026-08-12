#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="${1:-$(cd "$script_dir/../.." && pwd)}"
source "$script_dir/../../scripts/utils/log.sh"
source "$script_dir/../../scripts/utils/path.sh"

# Remove links and placeholders owned by superseded layouts.
cleanup_obsolete_links() {
  local old_starship_config="$HOME/.config/starship.toml"

  if symlink_points_within_dir "$old_starship_config" "$dotfiles_dir/starship"; then
    rm -f "$old_starship_config"
    info "Removed obsolete symlink: $old_starship_config"
  fi
}

# Replace the former APM directory link with a real user data directory.
migrate_apm_config_dir() {
  local source_dir="$dotfiles_dir/config/ai/apm"
  local target_dir="$HOME/.apm"
  local legacy_modules="$source_dir/apm_modules"
  local migrate_modules=false

  if [ -L "$target_dir" ]; then
    if ! symlink_points_to "$target_dir" "$source_dir"; then
      fail "Refusing to replace an unmanaged APM symlink: $target_dir"
    fi

    [ -d "$legacy_modules" ] && migrate_modules=true
    rm "$target_dir" || fail "Failed to remove the legacy APM symlink: $target_dir"
    info "Removed legacy APM directory symlink: $target_dir"
  elif [ -e "$target_dir" ] && [ ! -d "$target_dir" ]; then
    fail "APM path exists and is not a directory: $target_dir"
  fi

  if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir" || fail "Failed to create APM directory: $target_dir"
    info "Created directory: $target_dir"
  fi

  if [ "$migrate_modules" = true ]; then
    [ ! -e "$target_dir/apm_modules" ] || fail "Refusing to replace existing APM modules: $target_dir/apm_modules"
    mv "$legacy_modules" "$target_dir/apm_modules" || fail "Failed to migrate APM modules"
    info "Migrated APM modules: $target_dir/apm_modules"
  fi
}

# Remove stale skill links published by layouts that predate APM ownership.
cleanup_legacy_skill_links() {
  local dir_skills="${DIR_SKILLS:-$dotfiles_dir/config/ai/skills}"
  local legacy_dir_skills="$dotfiles_dir/ai/skills"
  local dir_apm_modules="${DIR_APM_MODULES:-$dotfiles_dir/config/ai/apm/apm_modules}"
  local skill_root
  local skill_path

  for skill_root in \
    "${DIR_CLAUDE_CODE_SKILLS:-$HOME/.claude/skills}" \
    "${DIR_CODEX_SKILLS:-$HOME/.codex/skills}" \
    "${DIR_COPILOT_SKILLS:-$HOME/.copilot/skills}" \
    "${DIR_GEMINI_CLI_SKILLS:-$HOME/.gemini/skills}"; do
    [ -d "$skill_root" ] || continue

    for skill_path in "$skill_root"/*; do
      [ -L "$skill_path" ] || continue
      if ! symlink_points_within_dir "$skill_path" "$dir_skills" &&
        ! symlink_points_within_dir "$skill_path" "$legacy_dir_skills"; then
        continue
      fi

      if [ ! -e "$skill_path" ] ||
        { [ ! -d "$dir_skills/$(basename "$skill_path")" ] && [ ! -d "$legacy_dir_skills/$(basename "$skill_path")" ]; }; then
        rm -f "$skill_path"
        info "Removed stale skill symlink: $skill_path"
      fi
    done
  done

  skill_root="${DIR_CODEX_SKILLS:-$HOME/.codex/skills}"
  [ -d "$skill_root" ] || return 0
  for skill_path in "$skill_root"/*; do
    [ -L "$skill_path" ] || continue
    symlink_points_within_dir "$skill_path" "$dir_apm_modules" || continue
    [ -e "$skill_path" ] && continue
    rm -f "$skill_path"
    info "Removed stale skill symlink: $skill_path"
  done
}

cleanup_obsolete_links
cleanup_legacy_skill_links
migrate_apm_config_dir
