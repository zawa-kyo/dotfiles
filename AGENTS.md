# Agent Guide

## Purpose

- `AGENTS.md` points agents to the right repository guidance.
- Keep detailed procedures and long background explanations out of this file.
- Put user-facing usage in `README.md`, repository-wide design decisions in `docs/`, and subsystem-specific rules near the relevant implementation.

## References

- `README.md`
  - Human-facing entry point.
  - Setup, daily usage, major commands, and repository overview.
- `README-ja.md`
  - Japanese version of `README.md`.
- `docs/index.md`
  - Design document index.
- `docs/architecture.md`
  - Repository structure and responsibility boundaries.
- `docs/command-model.md`
  - How standalone commands, shell functions, and `mise run` split responsibilities.
- `docs/abbreviation-policy.md`
  - Design principles for shell abbreviations.
- `docs/ai-tools.md`
  - AI tool management policy.
- `docs/operations.md`
  - Verification policy after changes.
- `dotfiles/editors/nvim/lua/policies/keybinds-policy.md`
  - Neovim keybinding design.
- `dotfiles/editors/nvim/lua/policies/tab-buffer-policy.md`
  - Neovim tab and buffer display policy.

## References by Change Area

- When changing `dotfiles/editors/nvim/`:
  - Check `dotfiles/editors/nvim/lua/policies/` first.
  - For keybindings, read `dotfiles/editors/nvim/lua/policies/keybinds-policy.md`.
  - For tab or buffer display, read `dotfiles/editors/nvim/lua/policies/tab-buffer-policy.md`.
- When changing `bin/`, `setup/`, `libexec/`, `mise.toml`, or `dotfiles/shell/`:
  - Read `docs/command-model.md` and `docs/abbreviation-policy.md`.
  - Follow the shared `fzf` policy in `docs/command-model.md` for scripts that use `fzf`.
- When changing `setup/homebrew/`:
  - Read the Homebrew section in `README.md` and `docs/operations.md`.
- When changing `setup/bun/`:
  - Read the Bun section in `README.md` and `docs/operations.md`.
- When changing `dotfiles/ai/`:
  - Read the AI Tools section in `README.md`, `docs/architecture.md`, and `docs/ai-tools.md`.
- When changing setup or usage documentation:
  - Update `README.md` and `README-ja.md`.
- When changing repository-wide design decisions:
  - Update `docs/`.

## Editing Rules

- Do not duplicate the content of `README.md` or `docs/` in `AGENTS.md`.
- Put human-facing instructions in `README.md`.
- Put repository-wide principles in `docs/`.
- Put subsystem-specific rules near the implementation.
- Use 2 spaces as the default indentation.
- Follow `.stylua.toml` for Lua.
- Match the existing shell script style and stay POSIX-friendly when practical.
- Use `rg` for text searches. Use `ast-grep` when a search or rewrite depends on code structure rather than exact text.
- Add a short English comment when adding a new function so its role is clear at a glance.
- Match the existing format for JSON, JSONC, TOML, and Markdown.
- Do not commit machine-specific values or secrets.
- Keep AI skill bodies in external apm package repositories by default. In this repository, keep only `dotfiles/ai/apm/apm.yml` dependencies and `dotfiles/ai/apm/apm.lock.yaml`.
- When suggesting use of an interactive CLI, recommend starting it in `tmux` first.

## Verification Rules

- Documentation-only changes:
  - No required tests.
  - Run `mise run format` after changing Markdown, TOML, JSON, or JSONC files.
- Changes under `dotfiles/editors/nvim/`:
  - Run `mise run format` after changing Lua or formatter-managed files.
  - Run `:checkhealth` in `nvim` after changing plugin, provider, or runtime configuration.
- Changes under `bin/`, `setup/`, `libexec/`, `mise.toml`, or `dotfiles/shell/`:
  - Run `mise run format` after changing shell, TOML, or Markdown files.
  - Run `mise run check-shell` after changing Bash or sh scripts.
  - Run `mise run check` for changes that affect setup, shell startup, PATH, or published commands.
- Changes to `setup/homebrew/Brewfile`:
  - Run `brew bundle check --file=setup/homebrew/Brewfile`.
- Changes under `setup/bun/`:
  - Run `mise run install-bun`.
- Confirm resolution with `bunx --version`.

## Documentation Rules

- When adding new setup instructions, update `README.md` and `README-ja.md`.
- When adding new repository-wide design principles, update `docs/`.
- When adding new Neovim rules, update `dotfiles/editors/nvim/lua/policies/`.
- When changing agent-facing references, update `AGENTS.md`.

## Language Versions

When you generate or edit prose in this repository, check whether an English Markdown file and a corresponding Japanese `*-ja.md` file cover the same content. When one exists, update both files in the same change so they stay aligned.

The Japanese counterpart of an English Markdown file is the `*-ja.md` file in the same directory.

Keep the versions equivalent in meaning, but write each one naturally in its own language. Do not make the Japanese file a mechanical line-by-line translation when a more natural Japanese expression preserves the same intent.

This applies especially to:

- `README.md` and `README-ja.md`
- `AGENTS.md` and `AGENTS-ja.md`

## Notes

- `README.md` and `AGENTS.md` are English.
- `README-ja.md`, `AGENTS-ja.md`, `docs/`, and policy files are Japanese by default.
- Keep `AGENTS.md` as a short entry point and avoid letting it grow too large.
