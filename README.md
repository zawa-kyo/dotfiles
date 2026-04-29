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

## VSCode

### Caution

If needed, back up the original configuration files before making changes.

### Synchronizing configuration files

Run the following commands to create symbolic links for the configuration files:

```sh
$ VSCODE_SETTING_DIR="$HOME/Library/Application Support/Code/User"

# Link settings.json
$ rm "$VSCODE_SETTING_DIR/settings.json"
$ ln -s "$(realpath vscode/settings.jsonc)" "$VSCODE_SETTING_DIR/settings.json"

# Link keybindings.json
$ rm "$VSCODE_SETTING_DIR/keybindings.json"
$ ln -s "$(realpath vscode/keybindings.jsonc)" "$VSCODE_SETTING_DIR/keybindings.json"
```

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
