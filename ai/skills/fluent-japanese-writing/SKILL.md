---
name: fluent-japanese-writing
description: Rewrite Japanese documentation and comments into fluent, human-readable Japanese while preserving code identifiers, commands, file paths, configuration keys, product names, and intentional technical terms. Use when the user asks to make Japanese prose more fluent or natural, remove awkward AI-like phrasing, reduce unnecessary English mixing, or align Japanese wording across docs.
---

# Fluent Japanese Writing

## Language Versions

This file and `SKILL-ja.md` describe the same skill. When changing either file, update the other in the same change so the English and Japanese versions stay aligned while remaining natural in each language.

## Overview

Improve Japanese prose in technical documents, comments, policies, and guides. The goal is not to translate every technical word mechanically, but to make the text read fluently to a Japanese-speaking maintainer while preserving precise technical meaning.

## Workflow

1. Identify the target text from the user request. If no range is specified, inspect the relevant diff or file.
2. Separate prose from literal technical artifacts.
   - Prose: sentences, headings, bullets, explanations, labels.
   - Technical artifacts: command names, file paths, config keys, code identifiers, package names, URLs, examples, and quoted values.
3. Rewrite prose into fluent Japanese.
4. Preserve technical artifacts unless the user explicitly asks to rename them.
5. Keep the repository's existing terminology and tone consistent.
6. Avoid broad rewrites that change the document's structure or intent unless the user asks for a larger edit.
7. After editing, search for the targeted awkward terms to confirm the intended cleanup is complete.

## Wording Guidelines

Prefer fluent Japanese for ordinary prose:

| Source term          | Preferred Japanese                                                    |
| -------------------- | --------------------------------------------------------------------- |
| `repository`         | `リポジトリ`                                                          |
| `public repository`  | `パブリックリポジトリ` or `公開リポジトリ`, depending on the sentence |
| `private repository` | `プライベートリポジトリ`                                              |
| `skill`              | `スキル`                                                              |
| `task`               | `タスク`                                                              |
| `shell function`     | `シェル関数`                                                          |
| `shell script`       | `シェルスクリプト`                                                    |
| `formatter`          | `フォーマッタ`                                                        |
| `editor`             | `エディタ`                                                            |
| `token`              | `トークン`                                                            |
| `user scope`         | `ユーザー単位`                                                        |
| `project scope`      | `プロジェクト単位`                                                    |
| `dependency`         | `依存関係`                                                            |
| `package`            | `パッケージ`                                                          |
| `tag`                | `タグ`                                                                |
| `commit`             | `コミット`                                                            |

Keep project-specific preferences when they are established:

- Use `lock ファイル`, not `ロックファイル`, when that is the local convention.
- Avoid overly formal or AI-like words such as `正本` when a plainer term works better.
- Use context-specific alternatives such as `管理元`, `置き場所`, `参照先`, `基準`, `まとめるディレクトリ`, or `まとめるファイル`.
- Avoid redundant phrases such as `ポリシー文書` when `ポリシー` is enough.

Preserve literal technical artifacts:

- Commands: `mise run install`, `uv run pre-commit run -a`
- File paths: `docs/index.md`, `.apm/skills`
- Config keys: `dependencies`, `interface.default_prompt`
- Skill names and package names: `review-essential-code`, `suggest-commit-messages`
- Product names and proper nouns: GitHub, Homebrew, Claude Code, Codex

## Review Checklist

- Does the result read like documentation written by a careful Japanese-speaking maintainer?
- Are unnecessary English words replaced with fluent Japanese?
- Are commands, paths, identifiers, config keys, and examples preserved exactly?
- Did any wording change alter the technical meaning?
- Are repeated terms consistent across the edited files?
- Did the cleanup avoid replacing proper nouns or code-like text by mistake?

## Output

When editing files, keep the final summary concise and mention the main wording categories changed. If no edits are needed, say that the prose is already fluent enough and identify any terms intentionally left unchanged.
