#!/usr/bin/env bash

# Common links
file_link "$DOTFILES_ROOT/packages/apm/apm.lock.yaml" "$HOME/.apm/apm.lock.yaml" all
file_link "$DOTFILES_ROOT/packages/apm/apm.yml" "$HOME/.apm/apm.yml" all
file_link "$DOTFILES_ROOT/packages/apm/config.json" "$HOME/.apm/config.json" all
file_link "$DOTFILES_ROOT/home/.codex/AGENTS.md" "$HOME/.codex/AGENTS.md" all
file_link "$DOTFILES_ROOT/home/.codex/AGENTS.md" "$HOME/.claude/CLAUDE.md" all
file_link "$DOTFILES_ROOT/home/.claude/settings.json" "$HOME/.claude/settings.json" all
file_link "$DOTFILES_ROOT/config/ai/codex/rules/default.rules" "$HOME/.codex/rules/default.rules" all
file_link "$DOTFILES_ROOT/home/.gitconfig" "$HOME/.gitconfig" all
file_link "$DOTFILES_ROOT/home/.zlogin" "$HOME/.zlogin" all
file_link "$DOTFILES_ROOT/home/.zlogout" "$HOME/.zlogout" all
file_link "$DOTFILES_ROOT/home/.zprofile" "$HOME/.zprofile" all
file_link "$DOTFILES_ROOT/home/.zshenv" "$HOME/.zshenv" all
file_link "$DOTFILES_ROOT/home/.zshrc" "$HOME/.zshrc" all
file_link "$DOTFILES_ROOT/home/.config/borders/bordersrc" "$HOME/.config/borders/bordersrc" all
file_link "$DOTFILES_ROOT/home/.config/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty" all
file_link "$DOTFILES_ROOT/home/.config/mise/mise.toml" "$HOME/.config/mise/mise.toml" all
file_link "$DOTFILES_ROOT/home/.config/mise/mise.lock" "$HOME/.config/mise/mise.lock" all
file_link "$DOTFILES_ROOT/home/.config/worktrunk/config.toml" "$HOME/.config/worktrunk/config.toml" all
file_link "$DOTFILES_ROOT/home/.config/zsh-abbr/user-abbreviations" "$HOME/.config/zsh-abbr/user-abbreviations" all
file_link "$DOTFILES_ROOT/home/.config/sheldon/plugins.toml" "$HOME/.config/sheldon/plugins.toml" all
file_link "$DOTFILES_ROOT/home/.config/zellij/config.kdl" "$HOME/.config/zellij/config.kdl" all

directory_link "$DOTFILES_ROOT/home/.config/mise/conf.d" "$HOME/.config/mise/conf.d" all
directory_link "$DOTFILES_ROOT/home/.config/nvim" "$HOME/.config/nvim" all
directory_link "$DOTFILES_ROOT/home/.config/starship" "$HOME/.config/starship" all
directory_link "$DOTFILES_ROOT/home/.config/wezterm" "$HOME/.config/wezterm" all

# macOS-specific links
file_link "$DOTFILES_ROOT/macos/Library/Application Support/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml" darwin
file_link "$DOTFILES_ROOT/macos/Library/Preferences/com.github.dalance.procs.config.toml" "$HOME/Library/Preferences/com.github.dalance.procs/config.toml" darwin
file_link "$DOTFILES_ROOT/macos/Library/Application Support/Code/User/settings.jsonc" "$HOME/Library/Application Support/Code/User/settings.json" darwin
file_link "$DOTFILES_ROOT/macos/Library/Application Support/Code/User/keybindings.jsonc" "$HOME/Library/Application Support/Code/User/keybindings.json" darwin
