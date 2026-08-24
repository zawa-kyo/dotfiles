# 🏠 dotfiles

Dotfiles repository for editors, terminals, CLI tools, and the local toolchain.

This README covers initial setup and common commands.
For design and operations, read `docs/`. For agent guidance, read `AGENTS.md`.

## ✨ Managed Areas

- Editor configuration for Neovim and VS Code
- Terminal-related configuration for Zsh, Starship, Ghostty, WezTerm, and Zellij
- macOS keyboard configuration for Karabiner-Elements
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

Install the latest standalone `mise` binary with the official installer. It places the binary at `~/.local/bin/mise`.

```sh
curl https://mise.run | sh
```

If you are migrating from the Homebrew version, restart the shell after installing the standalone binary. The current shell may still have an activation hook that points to `/opt/homebrew/bin/mise`.

```sh
exec zsh -l
mise --version
```

Trust the repository, then run the standard setup:

```sh
~/.local/bin/mise trust
~/.local/bin/mise bootstrap --yes
```

This command:

- applies the dotfile declarations in `mise.toml` and the platform config
- installs mise-managed tools
- applies apm-managed skills
- prepares the Bun global environment
- deploys the global Git pre-commit hook configuration for hk

The hk hook uses Git's config-based hook support and requires Git 2.54 or newer. It exits without doing anything in repositories that do not contain `hk.pkl`.

`mise run install` remains as a compatibility alias for `mise bootstrap`.
Homebrew packages are not installed by either command. On macOS, run `mise run install-brew` explicitly when you want to install missing Brewfile dependencies.

If an earlier setup installed mise with Homebrew, remove that formula after installing the standalone binary:

```sh
brew uninstall mise
```

To remove the standalone binary and mise-managed data, inspect the targets before running `mise implode`. The command keeps `~/.config/mise` unless you pass `--config`.

```sh
mise implode --dry-run
mise implode
```

## 🛠️ Common Commands

| Command                                     | Purpose                                                                 |
| ------------------------------------------- | ----------------------------------------------------------------------- |
| `mise bootstrap`                            | Run the standard local setup                                            |
| `mise bootstrap dotfiles status`            | Inspect declared dotfile targets without changing them                  |
| `mise bootstrap dotfiles apply --dry-run`   | Preview dotfile changes and conflicts                                   |
| `mise bootstrap dotfiles apply --yes`       | Apply the declared dotfile links                                        |
| `mise bootstrap dotfiles unapply --dry-run` | Preview removal of managed dotfiles                                     |
| `mise bootstrap dotfiles unapply --yes`     | Remove managed dotfiles that remain unchanged                           |
| `mise self-update`                          | Update the standalone mise binary immediately                           |
| `mise run format`                           | Format tracked files                                                    |
| `mise run check`                            | Run all repository checks                                               |
| `mise run install-brew`                     | Install missing Brewfile dependencies on macOS                          |
| `mise run test-deployment`                  | Test bootstrap behavior in isolated home directories                    |
| `mise run --continue-on-error upgrade`      | Update mise-managed tools, apm, Neovim, and Bun; also Homebrew on macOS |
| `mise tasks`                                | List available mise tasks                                               |

The setup links commands from `bin/` globally.
That directory contains small CLI tools for daily work, such as Git operations and task search.

The deployed global mise configuration enables automatic updates. mise checks for a new release periodically before eligible interactive commands. Set `MISE_AUTO_UPDATE=false` temporarily when you need to suppress it.

### Bun global packages

The repository tracks the Bun global `package.json`, `bun.lock`, and `bunfig.toml` files in `setup/bun/`.
`mise run install-bun` copies those files to `~/.bun/install/global` and installs dependencies there, so generated `node_modules/` content stays outside the repository.
`mise run upgrade-bun` updates the runtime directory and copies the changed manifest and lock file back to `setup/bun/`.

### Git worktrees

Worktrunk manages worktrees for repositories cloned with ghq. New worktrees are created next to the primary repository, and removing a worktree keeps its branch.

| Command                | Purpose                                                 |
| ---------------------- | ------------------------------------------------------- |
| `wt switch --branches` | Select a worktree or local branch, then switch to it    |
| `wt switch --remotes`  | Include remote branches when selecting a worktree       |
| `wt list`              | Show worktrees and their status                         |
| `wt remove`            | Remove the current worktree while preserving its branch |

## 🗂️ Repository Layout

| Path        | Role                                                 |
| ----------- | ---------------------------------------------------- |
| `dotfiles/` | Configuration linked into the home directory         |
| `bin/`      | Standalone CLI commands published to `~/.local/bin`  |
| `libexec/`  | Private helpers used by published commands           |
| `setup/`    | Machine setup declarations, scripts, and migrations  |
| `tests/`    | Go integration tests using isolated home directories |
| `docs/`     | Repository-wide design and operations policy         |

## 📚 Documentation

The README stays short. Use these documents for design and operations:

- [docs/index.md](docs/index.md): documentation index
- [docs/architecture.md](docs/architecture.md): repository layout and responsibility boundaries
- [docs/bootstrap-design.md](docs/bootstrap-design.md): mise bootstrap responsibilities and migration rules
- [docs/command-model.md](docs/command-model.md): standalone commands, shell functions, and mise tasks
- [docs/abbreviation.md](docs/abbreviation.md): shared naming policy for shell abbreviations and Neovim keybindings
- [docs/ai-tools.md](docs/ai-tools.md): AI tool and apm policy
- [docs/operations.md](docs/operations.md): verification policy by change type

Neovim-specific policies live in `dotfiles/editors/nvim/lua/policies/`.
