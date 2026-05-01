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

## Pre-commit

### Enabling Pre-commit for Protecting Sensitive Information

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

- Run `scripts/local/link-dotfiles.sh` from the cloned repository to link `git/.gitconfig` to `~/.gitconfig`.
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

When `terminal/.zshrc` is linked to `~/.zshrc`, `add-worktree` lets you select a local branch with `fzf` and creates a worktree next to the current repository.

```sh
add-worktree
```

To remove an existing linked worktree interactively:

```sh
delete-worktree
```

- The worktree path is created as `[repo]+[branch]`, with `/` in branch names replaced by `_`.
- If the selected branch already has a worktree, the existing path is printed instead of creating a duplicate.
- `delete-worktree` excludes the current worktree and stops if the selected worktree has uncommitted changes.
- `git` and `fzf` are required.

## VSCode

### Caution

If needed, back up the original configuration files before making changes. The linking script will not delete existing files; if `settings.json` or `keybindings.json` already exist, it will stop at those files with a warning instead of overwriting them.

### Synchronizing configuration files

On macOS, `scripts/local/link-dotfiles.sh` also creates symbolic links for VS Code configuration files in `~/Library/Application Support/Code/User`.

```sh
$ scripts/local/link-dotfiles.sh
```

If those files already exist and are not symlinks, the script leaves them in place and prints a warning. On non-macOS systems, it skips the VS Code links and prints a warning because the current target path is macOS-specific.

## Bun

To set up Bun’s global environment managed via this repository, run the following command:

```sh
mise run install-bun
```

This script will:

- Create a symbolic link between the Bun global directory and the repository's managed directory.
- Navigate to the Bun global directory.
- Install dependencies listed in `package.json`.

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
# Show explicitly installed packages (leaves)
brew leaves

# Clean up unused dependencies
brew autoremove

# Delete cached software files
brew cleanup

# Show dependencies of a specific package
brew deps [package_name]

# Show packages that depend on a specific package
brew uses [package_name]
```

## Task Runner

This repository uses `mise` for local task entrypoints.

```sh
mise run install
mise run install-pre-commit
mise run check-pre-commit
```

`mise run install` is also responsible for linking commands from `scripts/global/` into `~/.local/bin/` and generating `mise` task wrappers.

## Custom CLI and Mise Tasks

This repository treats `mise` as a task catalog and discovery interface, while keeping day-to-day execution on standalone commands.

### Overview

The intended split is:

- `~/.local/bin/`: the real command implementation
- `~/.config/mise/tasks/`: thin wrappers for `mise run` and task discovery
- `sheldon/abbreviations`: short forms for frequently used commands

This gives us three access paths for the same utility:

1. Direct execution: `reveal-repository-with-neovim`
2. Interactive catalog execution: `mise run reveal-repository-with-neovim`
3. Short daily input: an abbrev that expands to `reveal-repository-with-neovim`

### Why This Split

This design keeps command ownership and task discovery separate.

- Real commands should be executable without depending on `mise`.
- `mise` should provide a consistent catalog via `mise run` and `mise tasks ls --global`.
- `mise.toml` should stay small; file tasks under `~/.config/mise/tasks/` scale better than a large `[tasks]` block.
- Abbreviations should optimize typing, but the expanded command should remain visible in shell history.

### Repository Layout

The planned split inside this repository is:

- `scripts/local/`: commands intended to run only from inside this dotfiles repository
- `scripts/global/`: commands published to `~/.local/bin` and `mise` global tasks
- `scripts/utils/`: shared shell helpers, logging, sync helpers
- `.cache/mise/tasks/`: generated `mise` wrappers

This keeps setup scripts and interactive CLI commands separate.

- `scripts/global/` is the source of truth for published commands.
- `~/.local/bin/` should point at commands from `scripts/global/`.
- `.cache/mise/tasks/` should be generated from `scripts/global/`, not edited by hand.
- `~/.config/mise/tasks/` should be populated from the generated wrappers.

The generated wrapper directory is intentionally ignored by Git.

### Wrapper Generation

`mise` wrappers should not be maintained manually.

- Each command in `scripts/global/` should declare its own description metadata.
- A sync step should generate wrappers into `.cache/mise/tasks/`.
- The generated wrappers should then be linked or copied into `~/.config/mise/tasks/`.
- `mise run install` should create both the wrapper directory and the wrapper files.

This makes the real command implementation the single source of truth and keeps wrapper generation idempotent.

Each generated wrapper should delegate to the real command with `exec ... "$@"` and carry a `#MISE description="..."` header.

Example:

```sh
#!/usr/bin/env bash
#MISE description="Select a repository with fzf and open it in Neovim"
exec reveal-repository-with-neovim "$@"
```

### Abbreviation Policy

Abbreviations should follow the same design principle as [nvim/lua/policies/keybinds-policy.md](nvim/lua/policies/keybinds-policy.md): prefer meaning-based composition over ad-hoc memorization.

The shell version of that rule is:

- Design abbrevs as `verb + object`.
- If `verb + object` is not enough, add one short qualifier.
- Keep the verb set small and stable.
- Keep the object set small and stable.
- Prefer semantic names over implementation details.
- Only create abbrevs for commands used often enough to justify the mental slot.

Examples of good verb categories:

- `r`: reveal/open
- `a`: add/create/append
- `d`: delete/remove
- `s`: search/select

Examples of object categories:

- `w`: worktree
- `r`: repository
- `b`: branch
- `t`: task

Examples of qualifiers:

- `c`: VS Code
- `f`: Fork
- `l`: lazygit
- `n`: Neovim
- `z`: zoxide

The important point is not the exact letter choice, but consistency. Once a verb, object, or qualifier letter is assigned, it should keep the same meaning across commands.

Bad examples:

- Abbrevs that encode an implementation detail such as `mise run ...`
- One-off mnemonics that do not belong to a reusable dictionary
- Multiple abbrevs that use the same prefix letter with different meanings

Good examples:

- An add-related abbrev should start with `a`
- A delete-related abbrev should start with `d`
- A worktree-related abbrev should consistently use the same object key
- Repo-related commands should share the same `rr...` prefix
- The abbrev should expand to the real command, not to `mise run ...`

Current examples in this repository:

- `rr` -> `reveal-repository`
- `rrn` -> `reveal-repository-with-neovim`
- `rrc` -> `reveal-repository-with-code`
- `rrf` -> `reveal-repository-with-fork`
- `rrl` -> `reveal-repository-with-lazygit`
- `rrz` -> `reveal-repository-with-zoxide`
- `aw` -> `add-worktree`
- `dw` -> `delete-worktree`
- `sb` -> `search-bookmarks`
- `sbc` -> `search-bookmarks-chrome`
- `sbs` -> `search-bookmarks-safari`
- `st` -> `search-task`

### Operational Rule

The normal path should be:

- abbrev expands to the real command
- the real command runs directly from `~/.local/bin/`

`mise run` is still supported, but it is not the shortest daily path. Its role is discoverability, listing, description management, and a unified task interface.

### Shell-Resident Commands

Some commands should remain shell functions instead of being moved into standalone executables.

- `reveal-repository`
- `reveal-repository-with-zoxide`

The reason is semantic, not incidental: these commands change the current shell's working directory. If they run as external processes, the directory change only affects the child process and not the interactive shell the user is actually using.

So the intended split is:

- commands that open tools or perform independent actions can live in `scripts/global/`
- commands that must mutate the current shell session should stay in `.zshrc`

### Review Summary

This overall direction is sound and should age well.

- The separation between command implementation and task catalog is clean.
- The `mise` wrappers stay trivial and easy to maintain.
- Direct CLI execution keeps the interface portable.
- The only important constraint is abbreviation discipline: if abbrevs grow without a fixed `verb + object` vocabulary, cognitive load will climb quickly.

In short: keep the command in `~/.local/bin/`, keep the `mise` task thin, and keep abbrevs semantic and dictionary-driven.

### Current Implementation Scope

The next implementation step should stay intentionally small:

1. Rename `scripts/lib/` to `scripts/utils/`.
2. Create `scripts/local/` and `scripts/global/`.
3. Move the first three commands into `scripts/global/`:
   - `reveal-repository-with-neovim`
   - `add-worktree`
   - `delete-worktree`
4. Add one sync script that:
   - links `scripts/global/*` into `~/.local/bin/`
   - generates wrappers into `.cache/mise/tasks/`
   - reflects those wrappers into `~/.config/mise/tasks/`
5. Run that sync step from `mise run install`.
6. Keep `terminal/.zshrc` compatible while the commands move out of shell functions.
7. Verify four paths:
   - abbrev
   - direct command execution
   - `mise run <command>`
   - `mise tasks ls --global`

This scope is enough to validate the structure, generation flow, and install integration without migrating every existing helper at once.

### Deferred Commands

The first migration intentionally leaves some existing shell functions in place.

- `reveal-repository`
- `reveal-repository-with-zoxide`

These should stay in `.zshrc`, because they need to mutate the current shell session.
