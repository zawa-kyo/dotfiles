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
  local dotfiles_dir="$1"
  local source
  local target
  local link

  for link in "${file_links[@]}" "${directory_links[@]}" "${skill_links[@]}"; do
    IFS=":" read -r source target <<<"$link"

    if [[ -z "$source" || -z "$target" ]]; then
      fail "Invalid link definition: $link"
    fi

    if is_within_dir "$target" "$dotfiles_dir"; then
      fail "Refusing to create a link inside the repository: $target"
    fi
  done
}

# Fill file_links and directory_links for the given repo root.
populate_dotfiles_links() {
  local dotfiles_dir="$1"
  local dir_skills="${DIR_SKILLS:-$dotfiles_dir/ai/skills}"
  local dir_claude_code="${DIR_CLAUDE_CODE:-$HOME/.claude}"
  local dir_claude_code_skills="${DIR_CLAUDE_CODE_SKILLS:-$dir_claude_code/skills}"
  local dir_codex="${DIR_CODEX:-$HOME/.codex}"
  local dir_codex_skills="${DIR_CODEX_SKILLS:-$dir_codex/skills}"
  local dir_gemini_cli="${DIR_GEMINI_CLI:-$HOME/.gemini}"
  local dir_gemini_cli_skills="${DIR_GEMINI_CLI_SKILLS:-$dir_gemini_cli/skills}"
  local skill_dir
  local skill_name
  local skill_root

  file_links=(
    "$dotfiles_dir/git/.gitconfig:$HOME/.gitconfig"
    "$dotfiles_dir/terminal/.zlogin:$HOME/.zlogin"
    "$dotfiles_dir/terminal/.zlogout:$HOME/.zlogout"
    "$dotfiles_dir/terminal/.zprofile:$HOME/.zprofile"
    "$dotfiles_dir/terminal/.zshenv:$HOME/.zshenv"
    "$dotfiles_dir/terminal/.zshrc:$HOME/.zshrc"
    "$dotfiles_dir/borders/bordersrc:$HOME/.config/borders/bordersrc"
    "$dotfiles_dir/ghostty/config.ghostty:$HOME/.config/ghostty/config.ghostty"
    "$dotfiles_dir/mise/config.global.toml:$HOME/.config/mise/mise.toml"
    "$dotfiles_dir/mise/config.global.lock:$HOME/.config/mise/mise.lock"
    "$dotfiles_dir/sheldon/abbreviations:$HOME/.config/zsh-abbr/user-abbreviations"
    "$dotfiles_dir/sheldon/plugins.toml:$HOME/.config/sheldon/plugins.toml"
    "$dotfiles_dir/starship/starship.toml:$HOME/.config/starship.toml"
    "$dotfiles_dir/zellij/config.kdl:$HOME/.config/zellij/config.kdl"
  )

  case "$(uname -s)" in
  Darwin)
    local macos_app_support_dir="$HOME/Library/Application Support"

    file_links+=(
      "$dotfiles_dir/lazygit/config.yml:$macos_app_support_dir/lazygit/config.yml"
      "$dotfiles_dir/vscode/settings.jsonc:$macos_app_support_dir/Code/User/settings.json"
      "$dotfiles_dir/vscode/keybindings.jsonc:$macos_app_support_dir/Code/User/keybindings.json"
    )
    ;;
  *)
    warn "Skipping macOS-specific links on unsupported OS"
    ;;
  esac

  directory_links=(
    "$dotfiles_dir/mise/conf.d:$HOME/.config/mise/conf.d"
    "$dotfiles_dir/nvim:$HOME/.config/nvim"
    "$dotfiles_dir/wezterm:$HOME/.config/wezterm"
  )

  skill_links=()
  if [ -d "$dir_skills" ]; then
    for skill_dir in "$dir_skills"/*; do
      [ -d "$skill_dir" ] || continue
      [ -L "$skill_dir" ] && continue
      skill_name="$(basename "$skill_dir")"
      for skill_root in \
        "$dir_claude_code_skills" \
        "$dir_codex_skills" \
        "$dir_gemini_cli_skills"; do
        skill_links+=("$skill_dir:$skill_root/$skill_name")
      done
    done
  fi
}

# Remove stale skill symlinks previously published from the repo.
cleanup_skill_links() {
  local dotfiles_dir="$1"
  local dir_skills="${DIR_SKILLS:-$dotfiles_dir/ai/skills}"
  local dir_claude_code="${DIR_CLAUDE_CODE:-$HOME/.claude}"
  local dir_claude_code_skills="${DIR_CLAUDE_CODE_SKILLS:-$dir_claude_code/skills}"
  local dir_codex="${DIR_CODEX:-$HOME/.codex}"
  local dir_codex_skills="${DIR_CODEX_SKILLS:-$dir_codex/skills}"
  local dir_gemini_cli="${DIR_GEMINI_CLI:-$HOME/.gemini}"
  local dir_gemini_cli_skills="${DIR_GEMINI_CLI_SKILLS:-$dir_gemini_cli/skills}"
  local skill_root
  local skill_path
  local skill_target

  for skill_root in \
    "$dir_claude_code_skills" \
    "$dir_codex_skills" \
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
}
