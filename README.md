# dotfiles

Personal collection of .dotfiles for system configuration and customization.

## Preparation

Clone this repository into any directory you prefer:

```sh
git clone [repository_url]
```

Then navigate to the cloned repository directory to execute subsequent commands:

```sh
cd [cloned_repository_path]
```

## Pre-Hook

### Enabling Pre-Hook for Protecting Sensitive Information

This pre-hook helps prevent accidental commits of sensitive information, such as passwords or API keys. Follow these steps to set up pre-commit for your repository.

```sh
# Sync Python dev tools with uv
$ uv sync --group dev

# Enable and install pre-commit
$ uv run pre-commit install
```

### Notes

- This repository manages Python development dependencies with `uv` via `pyproject.toml`.
- If you have existing Git hooks, pre-commit will run in migration mode by default. Use the -f option to overwrite existing hooks and use only pre-commit.

## Git

This repository manages the base `~/.gitconfig` as a symlink.

- Run `scripts/link-dotfiles.sh` from the cloned repository to link `git/.gitconfig` to `~/.gitconfig`.
- Machine-specific overrides can be placed in `~/.gitconfig.local`.
- The base `.gitconfig` includes `~/.gitconfig.local` automatically, so a work machine can override `user.name` and `user.email` without changing the dotfiles-managed file.
- New repositories fetched with `ghq get` are stored under `~/Git/ghq`.
- Existing repositories under `~/Git` can remain where they are and do not need to be migrated immediately.

Example:

```ini
[user]
  name = Your Work Name
  email = your-work-email@example.com
```

### Interactive worktree

When `terminal/.zshrc` is linked to `~/.zshrc`, `create-worktree` lets you select a local branch with `fzf` and creates a worktree next to the current repository.

```sh
create-worktree
```

To remove an existing linked worktree interactively:

```sh
remove-worktree
```

- The worktree path is created as `[repo]+[branch]`, with `/` in branch names replaced by `_`.
- If the selected branch already has a worktree, the existing path is printed instead of creating a duplicate.
- `remove-worktree` excludes the current worktree and stops if the selected worktree has uncommitted changes.
- `git` and `fzf` are required.

## VSCode

### Caution

If needed, back up the original configuration files before making changes. The linking script will not delete existing files; if `settings.json` or `keybindings.json` already exist, it will stop at those files with a warning instead of overwriting them.

### Synchronizing configuration files

On macOS, `scripts/link-dotfiles.sh` also creates symbolic links for VS Code configuration files in `~/Library/Application Support/Code/User`.

```sh
$ scripts/link-dotfiles.sh
```

If those files already exist and are not symlinks, the script leaves them in place and prints a warning. On non-macOS systems, it skips the VS Code links and prints a warning because the current target path is macOS-specific.

## Bun

To set up Bun’s global environment managed via this repository, run the following command:

```sh
mise run install-bun
```

This script will: 1. Create a symbolic link between the Bun global directory and the repository’s managed directory. 2. Navigate to the Bun global directory. 3. Install dependencies listed in package.json.

After running the script, your Bun global environment will be fully configured and ready to use.

## Homebrew Package Management

This section describes how to manage Homebrew packages using the `Brewfile` included in this repository. It allows you to easily set up and maintain a consistent Homebrew environment across machines.

### Installation

To install the Homebrew packages listed in the `Brewfile`, navigate to the repository directory and run the following command:

```sh
cd [cloned_repository_path]
brew bundle --file=homebrew/Brewfile
```

This will install all the packages specified in the `homebrew/Brewfile`.

### Backing Up Homebrew Packages

To back up the currently installed Homebrew packages into the `Brewfile`:

1. Navigate to the repository directory:

   ```sh
   cd [cloned_repository_path]
   ```

2. Run the following command:

   ```sh
   brew bundle dump --file=homebrew/Brewfile --force
   ```

This will overwrite the existing `Brewfile` with the current list of installed packages.

### Useful Brew Commands

Here are some helpful commands:

```sh
// Show explicitly installed packages (leaves):
$ brew leaves

// Clean up unused dependencies:
brew autoremove

// Delete cached software files:
$ brew cleanup

// Show dependencies of a specific package:
$ brew deps [package_name]

// Show packages that depend on a specific package:
$ brew uses [package_name]
```

## Task Runner

This repository uses `mise` for local task entrypoints.

```sh
mise run install
mise run install-pre-commit
mise run check-pre-commit
```

## Custom CLI and Mise Tasks

This repository treats `mise` as a task catalog and discovery interface, while keeping day-to-day execution on standalone commands.

### Overview

The intended split is:

- `~/.local/bin/`: the real command implementation
- `~/.config/mise/tasks/`: thin wrappers for `mise run` and task discovery
- `sheldon/abbreviations`: short forms for frequently used commands

This gives us three access paths for the same utility:

1. Direct execution: `ghq-nvim`
2. Interactive catalog execution: `mise run ghq-nvim`
3. Short daily input: an abbrev that expands to `ghq-nvim`

### Why This Split

This design keeps command ownership and task discovery separate.

- Real commands should be executable without depending on `mise`.
- `mise` should provide a consistent catalog via `mise run` and `mise tasks ls --global`.
- `mise.toml` should stay small; file tasks under `~/.config/mise/tasks/` scale better than a large `[tasks]` block.
- Abbreviations should optimize typing, but the expanded command should remain visible in shell history.

### Directory Roles

Use `~/.local/bin/` for commands that should behave like normal CLI tools.

- They are invoked directly.
- They can later be rewritten in Bash, Go, Rust, or another language without changing the interface.
- They should remain usable even if `mise` is not involved.

Use `~/.config/mise/tasks/` for thin wrappers only.

- Each file should delegate to the real command with `exec ... "$@"`.
- Each file should carry a `#MISE description="..."` header.
- These wrappers exist for `mise run` and `mise tasks ls --global`, not for core logic.

Example:

```sh
#!/usr/bin/env bash
#MISE description="Select a ghq repository with fzf and open it in Neovim"
exec ghq-nvim "$@"
```

### Abbreviation Policy

Abbreviations should follow the same design principle as [nvim/lua/policies/keybinds-policy.md](/Users/kyohei/Git/ghq/github.com/zawa-kyo/dotfiles/nvim/lua/policies/keybinds-policy.md): prefer meaning-based composition over ad-hoc memorization.

The shell version of that rule is:

- Design abbrevs as `verb + object`.
- Keep the verb set small and stable.
- Keep the object set small and stable.
- Prefer semantic names over implementation details.
- Only create abbrevs for commands used often enough to justify the mental slot.

Examples of good verb categories:

- `g`: go/open/jump into a target context
- `c`: create
- `r`: remove
- `s`: search/select

Examples of object categories:

- `w`: worktree
- `r`: repository
- `n`: Neovim
- `b`: branch

The important point is not the exact letter choice, but consistency. Once a verb or object letter is assigned, it should keep the same meaning across commands.

Bad examples:

- Abbrevs that encode an implementation detail such as `mise run ...`
- One-off mnemonics that do not belong to a reusable dictionary
- Multiple abbrevs that use the same prefix letter with different meanings

Good examples:

- A create-related abbrev should start with `c`
- A worktree-related abbrev should consistently use the same object key
- The abbrev should expand to the real command, not to `mise run ...`

### Operational Rule

The normal path should be:

- abbrev expands to the real command
- the real command runs directly from `~/.local/bin/`

`mise run` is still supported, but it is not the shortest daily path. Its role is discoverability, listing, description management, and a unified task interface.

### Review Summary

This overall direction is sound and should age well.

- The separation between command implementation and task catalog is clean.
- The `mise` wrappers stay trivial and easy to maintain.
- Direct CLI execution keeps the interface portable.
- The only important constraint is abbreviation discipline: if abbrevs grow without a fixed `verb + object` vocabulary, cognitive load will climb quickly.

In short: keep the command in `~/.local/bin/`, keep the `mise` task thin, and keep abbrevs semantic and dictionary-driven.
