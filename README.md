# dotfiles

Personal dotfiles repository for editor, terminal, CLI, and local toolchain configuration.

## Overview

This repository manages:

- Neovim configuration in `nvim/`
- terminal and shell configuration in `terminal/`, `ghostty/`, `wezterm/`, `zellij/`, and `starship/`
- editor settings for VS Code in `vscode/`
- Homebrew packages in `homebrew/Brewfile`
- Bun global packages in `bun/`
- local setup and published CLI commands in `scripts/`
- AI tool configuration in `ai/`

Human-facing setup and usage live in this README. Repository-wide design decisions live under `docs/`. Agent-facing guidance lives in `AGENTS.md`.

## Quick Start

Clone the repository and enter the working directory:

```sh
git clone [repository_url]
cd [cloned_repository_path]
```

Install `mise` first if it is not already available in your shell.

```sh
brew install mise
```

Run the standard install flow:

```sh
mise run install
```

This install flow links dotfiles-managed files, syncs published global commands, installs local `mise` tools, prepares Bun globals, and installs the repository pre-commit hook.

## Daily Commands

Common entrypoints:

```sh
mise run install
mise run relink
mise run install-pre-commit
mise run check-pre-commit
mise run format
mise run upgrade
```

Useful direct commands after install:

```sh
add-worktree
delete-worktree
reveal-repository-with-neovim
search-task
```

## Repository Layout

- `nvim/`: Neovim configuration and plugin setup
- `vscode/`: VS Code settings and keybindings
- `scripts/local/`: setup and repository-local scripts
- `scripts/global/`: published standalone CLI commands
- `scripts/utils/`: shared shell helpers
- `homebrew/`: tracked `Brewfile`
- `bun/`: Bun global packages managed in-repo
- `sheldon/`: shell plugin manager config and abbreviations
- `ai/`: AI tool configuration and custom skills
- `src/samples/`: sample files for editor and LSP checks

## Subsystems

### Pre-commit

Python development dependencies are managed with `uv`.

```sh
uv sync --group dev
uv run pre-commit install
```

Run all checks:

```sh
uv run pre-commit run -a
```

### Git

The base `~/.gitconfig` is managed as a symlink from this repository.

- Run `scripts/local/link-dotfiles.sh` to link `git/.gitconfig`
- Put machine-specific overrides in `~/.gitconfig.local`
- Repositories fetched with `ghq get` are expected under `~/Git/ghq`

When `terminal/.zshrc` is linked, `add-worktree` and `delete-worktree` provide interactive worktree management with `fzf`.

### VS Code

On macOS, `scripts/local/link-dotfiles.sh` also links VS Code user files under `~/Library/Application Support/Code/User`.

If `settings.json` or `keybindings.json` already exist as real files, the script leaves them in place and prints a warning instead of overwriting them.

### AI Tools

AI tool configuration is grouped under `ai/`.

- `ai/skills/` is linked to a shared skills directory
- Codex custom skills are linked individually into `~/.codex/skills/`
- canonical paths are managed through `mise/conf.d/env.toml`

### Bun

Prepare the Bun global environment with:

```sh
mise run install-bun
```

This links the managed Bun global directory and installs dependencies from `bun/package.json`.

### Homebrew

Install tracked Homebrew packages:

```sh
brew bundle --file=homebrew/Brewfile
```

Update the tracked `Brewfile` from the current machine state:

```sh
brew bundle dump --file=homebrew/Brewfile --force
```

### Task Runner

This repository uses `mise` as the main task entrypoint and discovery interface.

- `mise run install` performs the standard local setup
- `mise run format` formats tracked source files
- `mise run check-pre-commit` runs the full repository checks
- published commands in `scripts/global/` are also exposed through generated `mise` task wrappers

## Design Documents

Repository-wide design and policy documents:

- [docs/index.md](docs/index.md)
- [docs/architecture.md](docs/architecture.md)
- [docs/command-model.md](docs/command-model.md)
- [docs/abbreviation-policy.md](docs/abbreviation-policy.md)
- [docs/operations.md](docs/operations.md)

Subsystem-local policies:

- [nvim/lua/policies/keybinds-policy.md](nvim/lua/policies/keybinds-policy.md)
- [nvim/lua/policies/tab-buffer-policy.md](nvim/lua/policies/tab-buffer-policy.md)
