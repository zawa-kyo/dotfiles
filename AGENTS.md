# Agent Guide

## Purpose

- `AGENTS.md` is the entry point for agents.
- Do not duplicate detailed procedures or long background explanations here. Keep this file focused on links to the right references.
- Human-facing usage belongs in `README.md`, repository-wide design decisions belong in `docs/`, and subsystem-specific rules belong near the relevant implementation.

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
  - Role split between standalone commands, shell functions, and `mise run`.
- `docs/abbreviation-policy.md`
  - Design principles for shell abbreviations.
- `docs/ai-tools.md`
  - Operating policy for AI tool management.
- `docs/operations.md`
  - Verification policy after changes.
- `nvim/lua/policies/keybinds-policy.md`
  - Neovim keybinding design.
- `nvim/lua/policies/tab-buffer-policy.md`
  - Neovim tab and buffer display policy.

## References by Change Area

- When changing `nvim/`:
  - Check `nvim/lua/policies/` first.
  - For keybindings, read `nvim/lua/policies/keybinds-policy.md`.
  - For tab or buffer display, read `nvim/lua/policies/tab-buffer-policy.md`.
- When changing `scripts/`, `mise.toml`, `terminal/`, or `sheldon/abbreviations`:
  - Read `docs/command-model.md` and `docs/abbreviation-policy.md`.
  - Follow the shared `fzf` policy in `docs/command-model.md` for scripts that use `fzf`.
- When changing `homebrew/`:
  - Read the Homebrew section in `README.md` and `docs/operations.md`.
- When changing `bun/`:
  - Read the Bun section in `README.md` and `docs/operations.md`.
- When changing `ai/`:
  - Read the AI Tools section in `README.md`, `docs/architecture.md`, and `docs/ai-tools.md`.
- When changing setup or usage instructions:
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
- Match the existing style for shell scripts and keep them as POSIX-friendly as practical.
- Add a short English comment when adding a new function so its role is clear at a glance.
- Match the existing format for JSON, JSONC, TOML, and Markdown.
- Do not commit machine-specific values or secrets.
- Manage AI skill bodies in external apm package repositories by default. In dotfiles, keep only `apm/apm.yml` dependencies and `apm/apm.lock.yaml`.

## Verification Rules

- Documentation-only changes:
  - No required tests.
  - Run `mise run format` after changing Markdown, TOML, JSON, or JSONC files.
- Changes under `nvim/`:
  - Run `mise run format` after changing Lua or formatter-managed files.
  - Run `:checkhealth` in `nvim` after changing plugin, provider, or runtime configuration.
- Changes under `scripts/`, `mise.toml`, `terminal/`, or `sheldon/abbreviations`:
  - Run `mise run format` after changing shell, TOML, or Markdown files.
  - Run `uv run pre-commit run -a` for changes that affect setup, shell startup, PATH, or published commands.
- Changes to `homebrew/Brewfile`:
  - Run `brew bundle check --file=homebrew/Brewfile`.
- Changes under `bun/`:
  - Run `mise run install-bun`.
  - Then confirm resolution with `bunx --version`.

## Documentation Rules

- When adding new setup instructions, update `README.md` and `README-ja.md`.
- When adding new repository-wide design principles, update `docs/`.
- When adding new Neovim rules, update `nvim/lua/policies/`.
- When changing agent-facing references, update `AGENTS.md`.

## Language Versions

When you generate or edit text in this repository, check whether an English Markdown file and a corresponding Japanese `*-ja.md` file exist for the same content. When one exists, update both files in the same change so they stay aligned.

The Japanese counterpart of an English Markdown file is the `*-ja.md` file in the same directory.

Keep the versions equivalent in meaning, but write each one naturally in its own language. Do not make the Japanese file a mechanical line-by-line translation when a more natural Japanese expression preserves the same intent.

This applies especially to:

- `README.md` and `README-ja.md`
- `AGENTS.md` and `AGENTS-ja.md`

## Notes

- `README.md` and `AGENTS.md` are English.
- `README-ja.md`, `AGENTS-ja.md`, `docs/`, and policy files are Japanese by default.
- Keep `AGENTS.md` as a short entry point and avoid letting it grow too large.
