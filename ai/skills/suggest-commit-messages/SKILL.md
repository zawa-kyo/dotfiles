---
name: suggest-commit-messages
description: Suggest concise English Conventional Commit message candidates from the current staged Git diff. Use when the user asks for commit message ideas, staged-diff commit messages, or phrasing like "staging されている差分からコミットメッセージを考えて" and wants Git checked again before answering.
---

# Suggest Commit Messages

## Overview

Draft a small set of concise English commit message candidates from the repository's currently staged changes. Always re-check Git state at execution time, even if prior context mentions cached or staged content.

## Workflow

1. Confirm the repository context with `git status --short` and inspect the staged diff with `git diff --cached --stat` plus `git diff --cached`.
2. If there is no staged diff, say that no staged changes were found and ask the user to stage changes before suggesting commit messages.
3. Infer the dominant intent of the staged diff, including whether the change is a feature, fix, refactor, style, chore, docs, test, or build change.
4. Generate 3-6 commit message candidates in concise English, using Conventional Commit style by default.
5. Prefer one-line messages unless the user asks for bodies. Keep the subject concise and action-oriented, with no trailing period.
6. If the staged diff contains unrelated changes, group candidates by likely change area or mention that splitting the commit may be clearer.

## Style

- Use lowercase Conventional Commit types such as `feat`, `fix`, `refactor`, `style`, `chore`, `docs`, `test`, `build`, or `ci`.
- Capitalize the first word of the subject after `type:`.
- Prefer messages without a scope unless one is clearly necessary for clarity.
- Match the user's preference for brevity. Good examples:
  - `feat: Simplify eza abbreviations`
  - `feat: Limit mise lockfiles to supported platforms`
  - `refactor: Move CLI tools from Homebrew to mise`
- Avoid overexplaining the diff in the final answer. The user asked for candidate messages, so lead with the candidates.

## Final Response

Respond in the user's language unless they specify otherwise, but keep commit messages in English. A compact bullet list is usually best:

```text
staged diff を確認しました。以下がコミットメッセージの候補です。

- feat: Simplify eza abbreviations
- feat: Limit mise lockfiles to supported platforms
- refactor: Move CLI tools from Homebrew to mise
```
