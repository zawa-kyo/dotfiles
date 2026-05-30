---
name: suggest-commit-messages
description: Suggest concise English Conventional Commit message candidates from the current Git diff. Use staged changes when present; otherwise use all unstaged changes, including untracked files. Use when the user asks for commit message ideas, staged-diff commit messages, or phrasing like "staging されている差分からコミットメッセージを考えて" and wants Git checked again before answering.
---

# Suggest Commit Messages

## Overview

Draft a small set of concise English commit message candidates from the repository's current changes. Prefer staged changes, but if nothing is staged, inspect all unstaged changes, including untracked files, instead. Always re-check Git state at execution time, even if prior context mentions cached, staged, unstaged, or untracked content.

## Workflow

1. Confirm the repository context with `git status --short`.
2. Inspect the staged diff first with `git diff --cached --stat` plus `git diff --cached`.
3. If there is no staged diff, inspect the full unstaged tracked diff with `git diff --stat` plus `git diff`.
4. Also inspect untracked files from `git status --short` or `git ls-files --others --exclude-standard`; for each relevant untracked text file, read enough content to understand its intent before suggesting messages.
5. If neither staged changes, unstaged tracked changes, nor untracked files exist, say that no Git changes were found and do not invent commit messages.
6. Infer the dominant intent of the selected changes, including whether the change is a feature, fix, refactor, style, chore, docs, test, or build change.
7. Generate 3-6 commit message candidates in concise English, using Conventional Commit style by default.
8. After listing candidates, recommend the single best message based on fit to the change content and natural English phrasing.
9. Prefer one-line messages unless the user asks for bodies. Keep the subject concise and action-oriented, with no trailing period.
10. If the selected changes contain unrelated work, group candidates by likely change area or mention that splitting the commit may be clearer.

## Style

- Use lowercase Conventional Commit types such as `feat`, `fix`, `refactor`, `style`, `chore`, `docs`, `test`, `build`, or `ci`.
- Capitalize the first word of the subject after `type:`.
- Prefer messages without a scope unless one is clearly necessary for clarity.
- When choosing the recommended message, prefer the candidate that most directly describes the selected changes while sounding natural to an English-speaking maintainer.
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

もっとも自然なものは次のとおりです。

- feat: Limit mise lockfiles to supported platforms
```

If no staged changes exist, make that fallback explicit:

```text
ステージング済みファイルが存在しなかったため、未ステージングの変更と未追跡ファイルを確認しました。以下がコミットメッセージの候補です。

- docs: Clarify commit message suggestion workflow
- docs: Fall back to unstaged changes for commit message suggestions
- docs: Update skill guidance for unstaged diffs

もっとも自然なものは次のとおりです。

- docs: Fall back to unstaged changes for commit message suggestions
```
