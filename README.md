# 🚀 dotfiles

Dotfiles repository for managing editors, terminals, CLI tools, and the local development toolchain.

This README covers initial setup and common commands.
For design principles and operational details, refer to `docs/`. For coding agent guidance, see `AGENTS.md`.

## Managed Areas

- Editor configuration for Neovim and VS Code
- Terminal-related configuration for Zsh, Starship, Ghostty, WezTerm, and Zellij
- macOS keyboard configuration for Karabiner-Elements
- Local tool configuration for Homebrew, Bun, mise, procs, and related utilities
- Standalone workflow CLI commands in `bin/`
- AI tool configuration for Codex, Claude Code, and related tools
- Sample test files for editor and LSP verification

## Quick Start

Clone the repository and enter the working directory:

```sh
git clone [repository_url]
cd [cloned_repository_path]
```

Install the latest standalone `mise` binary using the official installer, which places it at `~/.local/bin/mise`:

```sh
curl https://mise.run | sh
```

If you are migrating from the Homebrew version, restart your shell after installing the standalone binary. The active shell environment may still contain an activation hook pointing to `/opt/homebrew/bin/mise`.

```sh
exec zsh -l
mise --version
```

Trust the repository, then run the standard bootstrap setup:

```sh
~/.local/bin/mise trust
~/.local/bin/mise bootstrap --yes
```

This command executes the following steps:

- applies dotfile declarations in `mise.toml` and platform-specific configurations
- installs mise-managed tools
- applies apm-managed skills
- prepares the Bun global environment
- deploys the global Git pre-commit hook configuration for hk

The hk hook relies on Git's config-based hook mechanism and requires Git 2.54 or newer. It exits gracefully without performing any action in repositories that do not contain `hk.pkl`.

`mise run install` remains available as a backward-compatible alias for `mise bootstrap`.
Neither command automatically installs Homebrew packages. On macOS, run `mise run install-brew` explicitly when you need to install missing Brewfile dependencies.

If mise was previously installed via Homebrew, uninstall that formula after setting up the standalone binary:

```sh
brew uninstall mise
```

To remove the standalone binary and data managed by mise, review the targets before running `mise implode`. The command preserves `~/.config/mise` unless you explicitly pass `--config`:

```sh
mise implode --dry-run
mise implode
```

## Common Commands

| Command                                     | Purpose                                                                 |
| ------------------------------------------- | ----------------------------------------------------------------------- |
| `mise bootstrap`                            | Run the standard local setup                                            |
| `mise bootstrap dotfiles status`            | Inspect declared dotfile targets without modifying them                 |
| `mise bootstrap dotfiles apply --dry-run`   | Preview dotfile changes and conflicts                                   |
| `mise bootstrap dotfiles apply --yes`       | Apply declared dotfile symlinks                                         |
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
That directory contains small CLI tools for daily workflows, such as Git operations and task searches.

The deployed global mise configuration enables automatic updates. mise periodically checks for new releases before running eligible interactive commands. Set `MISE_AUTO_UPDATE=false` temporarily if you wish to suppress this behavior.

### Bun Global Packages

The repository tracks Bun's global `package.json`, `bun.lock`, and `bunfig.toml` under `setup/bun/`.
`mise run install-bun` copies these files to `~/.bun/install/global` and installs dependencies there, ensuring generated `node_modules/` artifacts remain outside the repository.
`mise run upgrade-bun` updates dependencies in the runtime directory and copies the updated manifest and lock file back to `setup/bun/`.

### Git Worktrees

Worktrunk manages worktrees for repositories cloned via ghq. New worktrees are created alongside the primary repository, and removing a worktree preserves its branch.

| Command                | Purpose                                                 |
| ---------------------- | ------------------------------------------------------- |
| `wt switch --branches` | Select a worktree or local branch, then switch to it    |
| `wt switch --remotes`  | Include remote branches when selecting a worktree       |
| `wt list`              | Show worktrees and their status                         |
| `wt remove`            | Remove the current worktree while preserving its branch |

## Repository Layout

| Path        | Role                                                 |
| ----------- | ---------------------------------------------------- |
| `dotfiles/` | Configuration symlinked into the home directory      |
| `bin/`      | Standalone CLI commands published to `~/.local/bin`  |
| `libexec/`  | Private helpers used by published commands           |
| `setup/`    | Machine setup declarations, scripts, and migrations  |
| `tests/`    | Go integration tests using isolated home directories |
| `docs/`     | Repository-wide design and operational policies      |

## Documentation

This README provides a high-level overview. Refer to [docs/README.md](./docs/README.md) as the index for detailed design decisions and operational procedures.
