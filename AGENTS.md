# Agent Guide

## Purpose

- `AGENTS.md` directs agents to the appropriate repository guidance.
- Keep detailed procedures and lengthy background explanations out of this file.
- Place user-facing usage in `README.md`, repository-wide design decisions in `docs/`, and subsystem-specific rules near their relevant implementations.

## References

- `README.md`
  - User-facing entry point (English).
  - Setup instructions, daily usage, major commands, and repository overview.
- `README-ja.md`
  - Japanese counterpart of `README.md`.
- `docs/README.md`
  - Design document index.
  - Follow its table of contents to repository-wide and tool-specific documents.

## References by Change Area

- When changing `dotfiles/editors/nvim/`:
  - Start from `docs/README.md` and follow the Neovim documentation link.
- When changing `bin/`, `setup/`, `libexec/`, `mise.toml`, or `dotfiles/shell/`:
  - Start from `docs/README.md` and follow the command model and abbreviation guides.
  - Follow the shared `fzf` policy outlined in the command model for scripts using `fzf`.
- When changing `setup/homebrew/`:
  - Read the Homebrew section in `README.md`, then consult the operations guide in `docs/README.md`.
- When changing `setup/bun/`:
  - Read the Bun section in `README.md`, then consult the operations guide in `docs/README.md`.
- When changing `dotfiles/ai/`:
  - Read the AI Tools section in `README.md`, then follow the architecture and AI tools guides in `docs/README.md`.
- When changing setup or usage documentation:
  - Update both `README.md` and `README-ja.md`.
- When changing repository-wide design decisions:
  - Update the relevant documents under `docs/`.

## Editing Rules

- Do not duplicate the contents of `README.md` or `docs/` in `AGENTS.md`.
- Keep user-facing instructions in `README.md`.
- Keep repository-wide principles in `docs/`.
- Keep subsystem-specific rules close to their implementations.
- Use 2 spaces as the default indentation.
- Follow `.stylua.toml` for Lua code.
- Match existing shell script styles and maintain POSIX compatibility where practical.
- Use `rg` for text searches. Use `ast-grep` when a search or rewrite depends on syntactic code structure rather than exact text.
- Add a concise English comment when introducing a new function so its purpose is clear at a glance.
- Match existing formatting conventions for JSON, JSONC, TOML, and Markdown.
- Do not commit machine-specific values or secrets.
- Maintain AI skill definitions in external apm package repositories by default. In this repository, keep only `dotfiles/ai/apm/apm.yml` dependencies and `dotfiles/ai/apm/apm.lock.yaml`.
- When suggesting an interactive CLI, recommend launching it inside `tmux` first.

## Verification Rules

- Documentation-only changes:
  - No automated tests required.
  - Run `mise run format` after modifying Markdown, TOML, JSON, or JSONC files.
- Changes under `dotfiles/editors/nvim/`:
  - Run `mise run format` after modifying Lua or formatter-managed files.
  - Run `:checkhealth` in `nvim` after changing plugin, provider, or runtime configuration.
- Changes under `bin/`, `setup/`, `libexec/`, `mise.toml`, or `dotfiles/shell/`:
  - Run `mise run format` after modifying shell, TOML, or Markdown files.
  - Run `mise run check-shell` after modifying Bash or sh scripts.
  - Run `mise run check` for changes that affect setup, shell startup, PATH, or published commands.
- Changes to `setup/homebrew/Brewfile`:
  - Run `brew bundle check --file=setup/homebrew/Brewfile`.
- Changes under `setup/bun/`:
  - Run `mise run install-bun`.
  - Verify resolution with `bunx --version`.

## Documentation Rules

- When adding new setup instructions, update both `README.md` and `README-ja.md`.
- When adding new repository-wide design principles, update `docs/`.
- When adding new Neovim rules, update `dotfiles/editors/nvim/docs/` and its index.
- When agent-facing reference paths change, update `AGENTS.md`.

## Language Versions

When generating or editing prose in this repository, check whether an English Markdown file and a corresponding Japanese `*-ja.md` file cover the same content. When a counterpart exists, update both files in the same change to keep them aligned.

The Japanese counterpart of an English Markdown file is the `*-ja.md` file in the same directory.

Keep both versions equivalent in meaning, but ensure each reads naturally in its own language. The Japanese file does not need to be a mechanical line-by-line translation as long as it preserves the original intent.

This applies especially to:

- `README.md` and `README-ja.md`
- `AGENTS.md` and `AGENTS-ja.md`

## Notes

- `README.md` and `AGENTS.md` are written in English.
- `README-ja.md`, `AGENTS-ja.md`, and documents under `docs/` directories are written in Japanese by default.
- Keep `AGENTS.md` concise as a lightweight entry point, avoiding unnecessary bloat.
