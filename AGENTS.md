# Repository Guidelines

## Project Structure & Module Organization
- `nvim/`: Neovim configuration (Lua) and plugin specs; formatted with Stylua.
- `vscode/`: Editor settings and keybindings (`*.jsonc`) to be symlinked to the VS Code user folder.
- `scripts/`: Setup helpers (e.g., `install-bun.sh`, `install.sh`, `source.sh`).
- `homebrew/`: `Brewfile` for reproducible package installs via Homebrew.
- `bun/`: Bun global packages managed in-repo (`package.json`, `bun.lock`).
- `sheldon/`: Zsh plugin manager config (`plugins.toml`) and common abbreviations.
- `wezterm/`, `terminal/`, `ghostty/`, `zellij/`, `starship.toml`: Terminal, multiplexer, and prompt configs.
- `src/samples/`: Small language samples used for editor/LSP checks.

## Build, Test, and Development Commands
- Install dev tools: `pip install poetry && poetry install`
- Enable pre-commit hooks: `poetry run pre-commit install`
- Run hooks on all files: `poetry run pre-commit run -a`
- Apply Homebrew bundle: `brew bundle --file=homebrew/Brewfile`
- Setup Bun globals: `sh scripts/install-bun.sh` (creates link and runs `bun install`)
- Sync VS Code: see `README.md` for `ln -s` commands and user path.

## Coding Style & Naming Conventions
- Indentation: 2 spaces (Lua enforced via `.stylua.toml`).
- Languages: Lua for Neovim, Bash for scripts, JSON/JSONC for editors.
- Naming: directories lower-case; scripts use hyphen-case (e.g., `install-bun.sh`).
- Formatting: run Stylua for Lua; keep JSON/JSONC valid; shell scripts POSIX-compatible where possible.

## Testing Guidelines
- Lint/security checks: `poetry run pre-commit run -a` (includes `detect-secrets`, `gitleaks`, YAML/JSON checks).
- Neovim health: open `nvim` and run `:checkhealth` after plugin changes.
- Bun setup: re-run `scripts/install-bun.sh` and confirm globals resolve (`bunx --version`).
- Homebrew: `brew doctor` and `brew bundle check --file=homebrew/Brewfile`.

## Commit & Pull Request Guidelines
- Commit style: use Conventional Commits (e.g., `feat: ...`, `fix: ...`, `refactor: ...`, `style: ...`).
- Scope clearly (e.g., `feat(nvim): add TOML LSP server`).
- PRs must include: summary of changes, affected areas (e.g., `nvim/`, `sheldon/`), platform/macOS version, and screenshots when UI/terminal look changes.
- Link related issues/tasks if applicable; keep PRs focused and small.

## Security & Configuration Tips
- Never commit secrets. Rely on pre-commit hooks and verify with `poetry run pre-commit run -a`.
- Machine-specific files should live outside the repo or be templated.
- When updating `Brewfile` use `brew bundle dump --file=homebrew/Brewfile --force` to capture exact state.
