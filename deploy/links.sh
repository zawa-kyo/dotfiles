#!/usr/bin/env bash

# Common links
file_link "$DOTFILES_ROOT/config/ai/apm/apm.lock.yaml" "$HOME/.apm/apm.lock.yaml" all
file_link "$DOTFILES_ROOT/config/ai/apm/apm.yml" "$HOME/.apm/apm.yml" all
file_link "$DOTFILES_ROOT/config/ai/apm/config.json" "$HOME/.apm/config.json" all
file_link "$DOTFILES_ROOT/config/ai/instructions/AGENTS.md" "$HOME/.codex/AGENTS.md" all
file_link "$DOTFILES_ROOT/config/ai/instructions/AGENTS.md" "$HOME/.claude/CLAUDE.md" all
file_link "$DOTFILES_ROOT/config/ai/claude/settings.json" "$HOME/.claude/settings.json" all
file_link "$DOTFILES_ROOT/config/ai/codex/rules/default.rules" "$HOME/.codex/rules/default.rules" all
file_link "$DOTFILES_ROOT/config/tools/git/.gitconfig" "$HOME/.gitconfig" all
file_link "$DOTFILES_ROOT/config/shell/terminal/.zlogin" "$HOME/.zlogin" all
file_link "$DOTFILES_ROOT/config/shell/terminal/.zlogout" "$HOME/.zlogout" all
file_link "$DOTFILES_ROOT/config/shell/terminal/.zprofile" "$HOME/.zprofile" all
file_link "$DOTFILES_ROOT/config/shell/terminal/.zshenv" "$HOME/.zshenv" all
file_link "$DOTFILES_ROOT/config/shell/terminal/.zshrc" "$HOME/.zshrc" all
file_link "$DOTFILES_ROOT/config/tools/borders/bordersrc" "$HOME/.config/borders/bordersrc" all
file_link "$DOTFILES_ROOT/config/terminal-apps/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty" all
file_link "$DOTFILES_ROOT/config/tools/mise/mise.toml" "$HOME/.config/mise/mise.toml" all
file_link "$DOTFILES_ROOT/config/tools/mise/mise.lock" "$HOME/.config/mise/mise.lock" all
file_link "$DOTFILES_ROOT/config/tools/worktrunk/config.toml" "$HOME/.config/worktrunk/config.toml" all
file_link "$DOTFILES_ROOT/config/shell/sheldon/abbreviations" "$HOME/.config/zsh-abbr/user-abbreviations" all
file_link "$DOTFILES_ROOT/config/shell/sheldon/plugins.toml" "$HOME/.config/sheldon/plugins.toml" all
file_link "$DOTFILES_ROOT/config/terminal-apps/zellij/config.kdl" "$HOME/.config/zellij/config.kdl" all

directory_link "$DOTFILES_ROOT/config/tools/mise/conf.d" "$HOME/.config/mise/conf.d" all
directory_link "$DOTFILES_ROOT/config/editors/nvim" "$HOME/.config/nvim" all
directory_link "$DOTFILES_ROOT/config/shell/starship" "$HOME/.config/starship" all
directory_link "$DOTFILES_ROOT/config/terminal-apps/wezterm" "$HOME/.config/wezterm" all

# macOS-specific links
file_link "$DOTFILES_ROOT/config/tools/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml" darwin
file_link "$DOTFILES_ROOT/config/tools/procs/procs.toml" "$HOME/Library/Preferences/com.github.dalance.procs/config.toml" darwin
file_link "$DOTFILES_ROOT/config/editors/vscode/settings.jsonc" "$HOME/Library/Application Support/Code/User/settings.json" darwin
file_link "$DOTFILES_ROOT/config/editors/vscode/keybindings.jsonc" "$HOME/Library/Application Support/Code/User/keybindings.json" darwin
