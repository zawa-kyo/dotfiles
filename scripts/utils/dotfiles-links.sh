#!/usr/bin/env bash

dotfiles_links_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dotfiles_links_dir/log.sh"

# Fill file_links and directory_links for the given repo root.
populate_dotfiles_links() {
  local dotfiles_dir="$1"
  local dir_skills="${DIR_SKILLS:-$dotfiles_dir/ai/skills}"
  local dir_skills_link="$HOME/.skills"
  local dir_claude_code="${DIR_CLAUDE_CODE:-$HOME/.claude}"
  local dir_claude_code_skills="${DIR_CLAUDE_CODE_SKILLS:-$dir_claude_code/skills}"
  local dir_codex="${DIR_CODEX:-$HOME/.codex}"
  local dir_codex_skills="${DIR_CODEX_SKILLS:-$dir_codex/skills}"
  local dir_gemini_cli="${DIR_GEMINI_CLI:-$HOME/.gemini}"
  local dir_gemini_cli_skills="${DIR_GEMINI_CLI_SKILLS:-$dir_gemini_cli/skills}"

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
    file_links+=(
      "$dotfiles_dir/vscode/settings.jsonc:$HOME/Library/Application Support/Code/User/settings.json"
      "$dotfiles_dir/vscode/keybindings.jsonc:$HOME/Library/Application Support/Code/User/keybindings.json"
    )
    ;;
  *)
    warn "Skipping VS Code links: unsupported OS for ~/Library/Application Support/Code/User"
    ;;
  esac

  directory_links=(
    "$dir_skills:$dir_skills_link"
    "$dir_skills_link:$dir_claude_code_skills"
    "$dir_skills_link:$dir_gemini_cli_skills"
    "$dotfiles_dir/nvim:$HOME/.config/nvim"
    "$dotfiles_dir/wezterm:$HOME/.config/wezterm"
  )

  codex_skill_links=()
  if [ -d "$dir_skills" ]; then
    local skill_dir
    for skill_dir in "$dir_skills"/*; do
      [ -d "$skill_dir" ] || continue
      codex_skill_links+=("$skill_dir:$dir_codex_skills/$(basename "$skill_dir")")
    done
  fi
}
