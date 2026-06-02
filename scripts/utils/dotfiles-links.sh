#!/usr/bin/env bash

dotfiles_links_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dotfiles_links_dir/log.sh"

# Return success when the candidate path itself is located inside the given directory.
is_within_dir() {
  local candidate="$1"
  local dir="$2"

  python3 - "$candidate" "$dir" <<'PY'
import os
import sys

candidate = os.path.abspath(os.path.expanduser(sys.argv[1]))
directory = os.path.abspath(os.path.expanduser(sys.argv[2]))

try:
    common = os.path.commonpath([candidate, directory])
except ValueError:
    raise SystemExit(1)

raise SystemExit(0 if common == directory else 1)
PY
}

# Return success when the symlink resolves inside the given directory.
symlink_points_within_dir() {
  local candidate="$1"
  local dir="$2"
  local target

  [ -L "$candidate" ] || return 1
  target="$(readlink "$candidate")" || return 1
  if [[ "$target" != /* ]]; then
    target="$(dirname "$candidate")/$target"
  fi
  is_within_dir "$target" "$dir"
}

# Refuse links that point back into the dotfiles repo.
validate_dotfiles_links() {
  local dir_dotfiles="$1"
  local source
  local target
  local link

  for link in "${file_links[@]}" "${directory_links[@]}"; do
    IFS=":" read -r source target <<<"$link"

    if [[ -z "$source" || -z "$target" ]]; then
      fail "Invalid link definition: $link"
    fi

    if is_within_dir "$target" "$dir_dotfiles"; then
      fail "Refusing to create a link inside the repository: $target"
    fi
  done
}

# Remove links from older layouts that are now superseded.
cleanup_obsolete_dotfiles_links() {
  local dir_dotfiles="$1"
  local old_starship_config="$HOME/.config/starship.toml"
  local codex_agents="$HOME/.codex/AGENTS.md"
  local claude_agents="$HOME/.claude/CLAUDE.md"
  local agent_instructions

  if symlink_points_within_dir "$old_starship_config" "$dir_dotfiles/starship"; then
    rm -f "$old_starship_config"
    info "Removed obsolete symlink: $old_starship_config"
  fi

  for agent_instructions in "$codex_agents" "$claude_agents"; do
    if [ -f "$agent_instructions" ] && [ ! -L "$agent_instructions" ] && [ ! -s "$agent_instructions" ]; then
      rm -f "$agent_instructions"
      info "Removed empty agent instructions placeholder: $agent_instructions"
    fi
  done
}

# Fill file_links and directory_links for the given repo root.
populate_dotfiles_links() {
  local dir_dotfiles="$1"

  file_links=(
    "$dir_dotfiles/ai/instructions/AGENTS.md:$HOME/.codex/AGENTS.md"
    "$dir_dotfiles/ai/instructions/AGENTS.md:$HOME/.claude/CLAUDE.md"
    "$dir_dotfiles/git/.gitconfig:$HOME/.gitconfig"
    "$dir_dotfiles/terminal/.zlogin:$HOME/.zlogin"
    "$dir_dotfiles/terminal/.zlogout:$HOME/.zlogout"
    "$dir_dotfiles/terminal/.zprofile:$HOME/.zprofile"
    "$dir_dotfiles/terminal/.zshenv:$HOME/.zshenv"
    "$dir_dotfiles/terminal/.zshrc:$HOME/.zshrc"
    "$dir_dotfiles/borders/bordersrc:$HOME/.config/borders/bordersrc"
    "$dir_dotfiles/ghostty/config.ghostty:$HOME/.config/ghostty/config.ghostty"
    "$dir_dotfiles/mise/config.global.toml:$HOME/.config/mise/mise.toml"
    "$dir_dotfiles/mise/config.global.lock:$HOME/.config/mise/mise.lock"
    "$dir_dotfiles/sheldon/abbreviations:$HOME/.config/zsh-abbr/user-abbreviations"
    "$dir_dotfiles/sheldon/plugins.toml:$HOME/.config/sheldon/plugins.toml"
    "$dir_dotfiles/zellij/config.kdl:$HOME/.config/zellij/config.kdl"
  )

  case "$(uname -s)" in
  Darwin)
    local macos_app_support_dir="$HOME/Library/Application Support"

    file_links+=(
      "$dir_dotfiles/lazygit/config.yml:$macos_app_support_dir/lazygit/config.yml"
      "$dir_dotfiles/procs/procs.toml:$HOME/Library/Preferences/com.github.dalance.procs/config.toml"
      "$dir_dotfiles/vscode/settings.jsonc:$macos_app_support_dir/Code/User/settings.json"
      "$dir_dotfiles/vscode/keybindings.jsonc:$macos_app_support_dir/Code/User/keybindings.json"
    )
    ;;
  *)
    warn "Skipping macOS-specific links on unsupported OS"
    ;;
  esac

  directory_links=(
    "$dir_dotfiles/apm:$HOME/.apm"
    "$dir_dotfiles/mise/conf.d:$HOME/.config/mise/conf.d"
    "$dir_dotfiles/nvim:$HOME/.config/nvim"
    "$dir_dotfiles/starship:$HOME/.config/starship"
    "$dir_dotfiles/wezterm:$HOME/.config/wezterm"
  )
}

# Remove stale skill symlinks previously published from the repo.
cleanup_skill_links() {
  local dir_dotfiles="$1"
  local dir_skills="${DIR_SKILLS:-$dir_dotfiles/ai/skills}"
  local dir_apm_modules="${DIR_APM_MODULES:-$dir_dotfiles/apm/apm_modules}"
  local dir_claude_code="${DIR_CLAUDE_CODE:-$HOME/.claude}"
  local dir_claude_code_skills="${DIR_CLAUDE_CODE_SKILLS:-$dir_claude_code/skills}"
  local dir_codex="${DIR_CODEX:-$HOME/.codex}"
  local dir_codex_skills="${DIR_CODEX_SKILLS:-$dir_codex/skills}"
  local dir_copilot="${DIR_COPILOT:-$HOME/.copilot}"
  local dir_copilot_skills="${DIR_COPILOT_SKILLS:-$dir_copilot/skills}"
  local dir_gemini_cli="${DIR_GEMINI_CLI:-$HOME/.gemini}"
  local dir_gemini_cli_skills="${DIR_GEMINI_CLI_SKILLS:-$dir_gemini_cli/skills}"
  local skill_root
  local skill_path
  local skill_target

  for skill_root in \
    "$dir_claude_code_skills" \
    "$dir_codex_skills" \
    "$dir_copilot_skills" \
    "$dir_gemini_cli_skills"; do
    [ -d "$skill_root" ] || continue

    for skill_path in "$skill_root"/*; do
      [ -L "$skill_path" ] || continue
      if ! symlink_points_within_dir "$skill_path" "$dir_skills"; then
        continue
      fi

      skill_target="$(readlink "$skill_path")"
      if [[ "$skill_target" != /* ]]; then
        skill_target="$(dirname "$skill_path")/$skill_target"
      fi

      if [ ! -e "$skill_target" ]; then
        rm -f "$skill_path"
        info "Removed stale skill symlink: $skill_path"
        continue
      fi

      if [ ! -d "$dir_skills/$(basename "$skill_path")" ]; then
        rm -f "$skill_path"
        info "Removed stale skill symlink: $skill_path"
      fi
    done
  done

  [ -d "$dir_codex_skills" ] || return 0

  for skill_path in "$dir_codex_skills"/*; do
    [ -L "$skill_path" ] || continue
    if ! symlink_points_within_dir "$skill_path" "$dir_apm_modules"; then
      continue
    fi

    skill_target="$(readlink "$skill_path")"
    if [[ "$skill_target" != /* ]]; then
      skill_target="$(dirname "$skill_path")/$skill_target"
    fi

    if [ ! -e "$skill_target" ]; then
      rm -f "$skill_path"
      info "Removed stale skill symlink: $skill_path"
    fi
  done
}
