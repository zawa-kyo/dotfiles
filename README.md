# 🏠 dotfiles

Dotfiles repository for editors, terminals, CLI tools, and the local toolchain.

This README covers initial setup and common commands.
For design and operations, read `docs/`. For agent guidance, read `AGENTS.md`.

## ✨ Managed Areas

- Editor configuration for Neovim and VS Code
- Terminal-related configuration for Zsh, Starship, Ghostty, WezTerm, and Zellij
- Local tool configuration for Homebrew, Bun, mise, procs, and related tools
- Standalone workflow CLI commands in `scripts/global/`
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

Run the standard setup task:

```sh
mise run install
```

This task:

- links dotfiles-managed files
- syncs utility commands
- installs mise-managed tools
- applies apm-managed skills
- prepares the Bun global environment
- installs the pre-commit hook

## 🛠️ Common Commands

| Command                     | Purpose                                                      |
| --------------------------- | ------------------------------------------------------------ |
| `mise run install`          | Run the standard local setup                                 |
| `mise run relink`           | Relink dotfiles-managed files without overwriting real files |
| `mise run format`           | Format tracked files                                         |
| `mise run check-pre-commit` | Run all pre-commit checks                                    |
| `mise run upgrade`          | Update mise, apm, Neovim, Bun, and Homebrew dependencies     |
| `mise tasks`                | List available mise tasks                                    |

The setup links commands from `scripts/global/` globally.
That directory contains small CLI tools for daily work, such as Git operations and task search.

## 🗂️ Repository Layout

| Path                    | Role                                                        |
| ----------------------- | ----------------------------------------------------------- |
| `config/editors/`       | Neovim, VS Code, and editor sample configuration            |
| `config/shell/`         | Shell configuration for Zsh, Sheldon, Starship, and others  |
| `config/terminal-apps/` | Terminal app configuration for Ghostty, WezTerm, and Zellij |
| `config/tools/`         | Tool configuration for Homebrew, Bun, Git, mise, and procs  |
| `config/ai/`            | Agent instructions and apm-managed AI tool settings         |
| `scripts/local/`        | Local setup and maintenance scripts                         |
| `scripts/global/`       | Published standalone CLI commands                           |
| `scripts/utils/`        | Shared helpers for shell scripts                            |
| `docs/`                 | Repository-wide design and operations policy                |

## 📚 Documentation

The README stays short. Use these documents for design and operations:

- [docs/index.md](docs/index.md): documentation index
- [docs/architecture.md](docs/architecture.md): repository layout and responsibility boundaries
- [docs/command-model.md](docs/command-model.md): standalone commands, shell functions, and mise tasks
- [docs/abbreviation-policy.md](docs/abbreviation-policy.md): shell abbreviation policy
- [docs/ai-tools.md](docs/ai-tools.md): AI tool and apm policy
- [docs/operations.md](docs/operations.md): verification policy by change type

Neovim-specific policies live in `config/editors/nvim/lua/policies/`.
