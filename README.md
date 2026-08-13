# 🏠 dotfiles

Dotfiles repository for editors, terminals, CLI tools, and the local toolchain.

This README covers initial setup and common commands.
For design and operations, read `docs/`. For agent guidance, read `AGENTS.md`.

## ✨ Managed Areas

- Editor configuration for Neovim and VS Code
- Terminal-related configuration for Zsh, Starship, Ghostty, WezTerm, and Zellij
- Local tool configuration for Homebrew, Bun, mise, procs, and related tools
- Standalone workflow CLI commands in `bin/`
- AI tool configuration for Codex, Claude Code, and related tools
- Sample files for editor and LSP checks

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

Run the standard setup:

```sh
mise bootstrap
```

This command:

- applies the dotfile declarations in `mise.toml` and the platform config
- installs mise-managed tools
- applies apm-managed skills
- prepares the Bun global environment
- installs the pre-commit hook

`mise run install` remains as a compatibility alias for `mise bootstrap`.
Homebrew packages are not installed by either command. On macOS, run `mise run install-brew` explicitly when you want to install missing Brewfile dependencies.

## 🛠️ Common Commands

| Command                                   | Purpose                                                  |
| ----------------------------------------- | -------------------------------------------------------- |
| `mise bootstrap`                          | Run the standard local setup                             |
| `mise bootstrap dotfiles status`          | Inspect declared dotfile targets without changing them   |
| `mise bootstrap dotfiles apply --dry-run` | Preview dotfile changes and conflicts                    |
| `mise bootstrap dotfiles apply --yes`     | Apply the declared dotfile links                         |
| `mise run format`                         | Format tracked files                                     |
| `mise run check-pre-commit`               | Run all pre-commit checks                                |
| `mise run install-brew`                   | Install missing Brewfile dependencies on macOS           |
| `mise run test-deployment`                | Test bootstrap behavior in isolated home directories     |
| `mise run upgrade`                        | Update mise, apm, Neovim, Bun, and Homebrew dependencies |
| `mise tasks`                              | List available mise tasks                                |

The setup links commands from `bin/` globally.
That directory contains small CLI tools for daily work, such as Git operations and task search.

### Bun global packages

The repository tracks the Bun global `package.json`, `bun.lock`, and `bunfig.toml` files in `config/tools/bun/`.
`mise run install-bun` copies those files to `~/.bun/install/global` and installs dependencies there, so generated `node_modules/` content stays outside the repository.
`mise run upgrade-bun` updates the runtime directory and copies the changed manifest and lock file back to `config/tools/bun/`.

### Git worktrees

Worktrunk manages worktrees for repositories cloned with ghq. New worktrees are created next to the primary repository, and removing a worktree keeps its branch.

| Command                | Purpose                                                 |
| ---------------------- | ------------------------------------------------------- |
| `wt switch --branches` | Select a worktree or local branch, then switch to it    |
| `wt switch --remotes`  | Include remote branches when selecting a worktree       |
| `wt list`              | Show worktrees and their status                         |
| `wt remove`            | Remove the current worktree while preserving its branch |

## 🗂️ Repository Layout

| Path       | Role                                                        |
| ---------- | ----------------------------------------------------------- |
| `config/`  | Configuration grouped by the tool or domain being managed   |
| `bin/`     | Standalone CLI commands published to `~/.local/bin`         |
| `tasks/`   | Setup and maintenance scripts not covered by mise bootstrap |
| `libexec/` | Shared helpers for shell scripts                            |
| `deploy/`  | Narrowly scoped migrations from superseded layouts          |
| `tests/`   | Go integration tests using isolated home directories        |
| `docs/`    | Repository-wide design and operations policy                |

## 📚 Documentation

The README stays short. Use these documents for design and operations:

- [docs/index.md](docs/index.md): documentation index
- [docs/architecture.md](docs/architecture.md): repository layout and responsibility boundaries
- [docs/bootstrap-design.md](docs/bootstrap-design.md): mise bootstrap responsibilities and migration rules
- [docs/command-model.md](docs/command-model.md): standalone commands, shell functions, and mise tasks
- [docs/abbreviation-policy.md](docs/abbreviation-policy.md): shell abbreviation policy
- [docs/ai-tools.md](docs/ai-tools.md): AI tool and apm policy
- [docs/operations.md](docs/operations.md): verification policy by change type

Neovim-specific policies live in `config/editors/nvim/lua/policies/`.
