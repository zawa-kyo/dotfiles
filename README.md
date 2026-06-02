# 🏠 dotfiles

Personal dotfiles repository for editor, terminal, CLI, and local toolchain configuration.

## ✨ Overview

This repository includes:

- Neovim configuration in `nvim/`
- terminal and shell configuration in `terminal/`, `ghostty/`, `wezterm/`, `zellij/`, and `starship/`
- editor settings for VS Code in `vscode/`
- Homebrew packages in `homebrew/Brewfile`
- Bun global packages in `bun/`
- procs configuration in `procs/`
- local setup and published CLI commands in `scripts/`
- AI tool configuration in `ai/`

This README covers setup and daily usage. See `docs/` for repository design and `AGENTS.md` for agent guidance.

## 🚀 Quick Start

Clone the repository and enter the working directory:

```sh
git clone [repository_url]
cd [cloned_repository_path]
```

Install `mise` first if it is not already available in your shell.

```sh
brew install mise
```

Run the installer:

```sh
mise run install
```

`mise run install` links dotfiles-managed files, syncs published global commands, installs local `mise` tools, prepares Bun globals, and installs the repository pre-commit hook.

## 🛠️ Daily Commands

Mise tasks:

```sh
mise run install
mise run relink
mise run install-pre-commit
mise run check-pre-commit
mise run format
mise run upgrade
```

Global commands:

```sh
add-worktree
add-worktree-remote
delete-worktree
reveal-repository-with-neovim
search-abbreviation
search-task
switch-branch
switch-branch-remote
```

## 🗂️ Repository Layout

- `nvim/`: Neovim configuration and plugin setup
- `vscode/`: VS Code settings and keybindings
- `scripts/local/`: setup and repository-local scripts
- `scripts/global/`: published standalone CLI commands
- `scripts/utils/`: shared shell helpers
- `homebrew/`: tracked `Brewfile`
- `bun/`: Bun global packages managed in-repo
- `procs/`: process viewer configuration
- `sheldon/`: shell plugin manager config and abbreviations
- `ai/`: AI tool configuration
- `src/samples/`: sample files for editor and LSP checks

## 🧩 Subsystems

### 🪝 Pre-commit

`uv` manages Python development dependencies.

```sh
uv sync --group dev
uv run pre-commit install
```

Run all checks:

```sh
uv run pre-commit run -a
```

### 🌿 Git

This repository links the base `$HOME/.gitconfig`.

- Run `scripts/local/link-dotfiles.sh` to link `git/.gitconfig`
- Put machine-specific overrides in `$HOME/.gitconfig.local`
- Keep repositories fetched with `ghq get` under `$GHQ_ROOT`
- `mise/conf.d/env.toml` sets `$GHQ_ROOT` to `$HOME/Git/ghq` by default

When `terminal/.zshrc` is linked, `add-worktree`, `add-worktree-remote`, `switch-branch`, `switch-branch-remote`, and `delete-worktree` provide interactive branch and worktree management with `fzf`.

### 🚀 Starship

Starship uses `$STARSHIP_CONFIG`, with the default set from `$STARSHIP_DEFAULT_THEME` on shell startup.

Place custom themes in `starship/themes/*.toml`, then run `search-theme` or the `sT` abbreviation to switch the current shell session. Opening a new terminal restores the default theme.

### 🧑‍💻 VS Code

On macOS, `scripts/local/link-dotfiles.sh` also links VS Code user files into the VS Code user config directory.

If `settings.json` or `keybindings.json` already exist as real files, the script leaves them in place and prints a warning instead of overwriting them.

### 🤖 AI Tools

The `ai/` directory contains AI tool settings.

- Reusable skills are tracked as apm dependencies in `apm/apm.yml`
- `mise run install` runs `apm install -g` and applies the locked skills
- `mise run upgrade` updates apm-managed skills and `apm/apm.lock.yaml`
- `mise/conf.d/env.toml` defines canonical paths
- Custom skills should respond in the user's request language unless the requested artifact has an explicit language requirement such as English commit messages

### 🥟 Bun

Prepare the Bun global environment with:

```sh
mise run install-bun
```

This links the managed Bun global directory and installs dependencies from `bun/package.json`.

### 🍺 Homebrew

Install tracked Homebrew packages:

```sh
brew bundle --file=homebrew/Brewfile
```

Update the tracked `Brewfile` from the current machine state:

```sh
brew bundle dump --file=homebrew/Brewfile --force
```

### 🏃 Task Runner

`mise` is the main entry point for running and discovering tasks.

- `mise run install` performs the standard local setup
- `mise run format` formats tracked files
- `mise run check-pre-commit` runs the full repository checks
- published commands in `scripts/global/` are also exposed through generated `mise` task wrappers

## 📚 Design Documents

Repository-wide design and policy documents:

- [docs/index.md](docs/index.md)
- [docs/architecture.md](docs/architecture.md)
- [docs/command-model.md](docs/command-model.md)
- [docs/abbreviation-policy.md](docs/abbreviation-policy.md)
- [docs/ai-tools.md](docs/ai-tools.md)
- [docs/operations.md](docs/operations.md)

Subsystem-local policies:

- [nvim/lua/policies/keybinds-policy.md](nvim/lua/policies/keybinds-policy.md)
- [nvim/lua/policies/tab-buffer-policy.md](nvim/lua/policies/tab-buffer-policy.md)
