# dotfiles

Personal collection of dotfiles for system configuration and customization.

## Preparation

To get started, clone this repository into your home directory:

```sh
git clone [repository_url] $HOME/dotfiles
```

After cloning the repository, navigate to the project directory to execute subsequent commands:

```sh
cd $HOME/dotfiles
```

## Pre-Hook

### Enabling Pre-Hook for Protecting Sensitive Information

This pre-hook helps prevent accidental commits of sensitive information, such as passwords or API keys. Follow these steps to set up pre-commit for your repository.

```sh
# Install poetry
$ pip install poetry

# Enable and install pre-commit
$ poetry install
$ poetry run pre-commit install
```

### Notes

- Ensure that your repository includes a `pyproject.toml` file with pre-commit listed as a development dependency.
- If you have existing Git hooks, pre-commit will run in migration mode by default. Use the -f option to overwrite existing hooks and use only pre-commit.

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
sh scripts/install-bun.sh
```

This script will:
	1. Create a symbolic link between the Bun global directory and the repository’s managed directory.
	2. Navigate to the Bun global directory.
	3. Install dependencies listed in package.json.

After running the script, your Bun global environment will be fully configured and ready to use.
