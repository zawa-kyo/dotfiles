# Global Agent Guide

## Core Principles

- This file provides global, user-level guidance for coding agents.
- When a project-specific instruction file or explicit user request provides more specific guidance, follow that instead.
- Use the following priority order:
  - Follow explicit user requests first.
  - Then follow the nearest project- or directory-level instruction file.
  - Treat this global file as the default unless more specific guidance overrides it.
  - When instructions conflict, articulate the conflict and follow the more specific instruction.
- Keep changes scoped to the user's request and avoid unrelated refactoring.
- Prefer the project's existing patterns, tools, and helper APIs over introducing new conventions.

## Interaction

- Respond in the user's request language unless the requested artifact has its own specific language requirement.
  - Reply in Japanese when the user asks in Japanese, and in English when the user asks in English.
- Keep progress updates and final answers concise, concrete, and focused on the current task.
- Explicitly state assumptions that affect the implementation or review result; do not leave them implicit.
- Ask questions when missing information blocks progress or when guessing would introduce risks.

## Implementation Practice

- Read surrounding code and project documentation before making non-trivial changes.
- When checking how a library, SDK, CLI, or similar tool behaves or should be configured, consult its official documentation first. When the goal can be achieved through officially recommended and maintained settings, options, or environment variables, use those. If no official path exists, propose a practical workaround as a compromise.
- Ensure code clearly reflects the processing flow, and write tests that demonstrate behavior from the user's perspective.
- Insert blank lines between semantically distinct code blocks to enhance readability.
- Use commit message bodies or comments to explain Why or Why not when context is important.
- Add comments only when they clarify behavior that is difficult to infer directly from the code.
- Follow the repository's formatter and style rules when modifying formatter-managed files.
- If tests or checks are skipped, explain why and describe any remaining limitations.

## Safety and Ownership

- Ask for confirmation before performing destructive operations, broad filesystem changes, external publication, or actions that may incur costs.
- If a task requires installing dependencies, modifying global tools, or altering machine-level configurations, ask the user before proceeding.
- Do not use destructive commands unless the user explicitly requests them.
- Do not stage, unstage, commit, push, or publish changes unless the user explicitly asks for that Git operation.
- Treat any command that modifies the Git index as a staging or unstaging operation, even when it also alters the working tree. This includes `git add`, `git mv`, `git rm`, `git restore --staged`, and similar commands. Do not execute them unless the user explicitly requests that Git operation.
- When moving, renaming, or deleting tracked files without an explicit staging request, use standard filesystem operations such as `mv` and verify with `git status --short` that the changes remain unstaged.
- Do not revert or overwrite changes you did not author unless explicitly requested.
- Keep generated values, machine-specific values, secrets, local paths, and credentials out of commits.
- Do not inspect secrets unless the user explicitly requests that specific file or value.

## Review and Reporting

- In code reviews, present concrete findings ordered by severity.
- Prioritize quality issues, regressions, missing test coverage, data loss, security risks, and maintainability concerns.
- If no blocking issues are found, state so clearly and mention any remaining verification gaps.
- Summarize what changed, what was verified, and any residual risks.
- Mention modified files when that helps the user review the work.
- Do not claim that tests passed unless they were actually executed.

## Prose and Maintenance

- When writing Japanese, compose thoughts directly in Japanese rather than drafting in English and translating. Translationese often leads to excessive katakana or awkward sentence structures.
- Use the `revise-japanese-writing` skill as the source of truth for detailed Japanese tone, notation, terminology, and punctuation decisions.
- When editing Japanese Markdown, comments, policies, or guides, apply the `revise-japanese-writing` skill and match the existing document's tone and terminology.
- In regular conversation output, also respect the Japanese guidance from `revise-japanese-writing`: do not omit particles, avoid translationese, and avoid unnecessary English mixing.
- When editing prose, use semantic line breaks where line breaks do not affect rendering or meaning.
- Use bold text sparingly, mainly for initial definitions or note labels.
- Prefer flowing prose when a long bullet list would read mechanically.
- Before adding to or revising an existing section, review that section and the document's overall structure. If the change suggests that the section structure should be reorganized, propose the reorganization first and wait for user confirmation before proceeding.
- In documents where the order or content may change over time, do not hardcode numbers into headings or prose. Use Markdown list syntax when sequence matters.
- Introduce technical terms with a short explanation instead of assuming the reader knows them.
- Use document titles or concept names when filenames, paths, or code identifiers interrupt the prose flow.
- When illustrating complex structures, use maintainable diagram notation such as Mermaid instead of ASCII art.
- Avoid overusing callout boxes or note blocks when the point fits naturally in the surrounding prose.
- Organize this file from abstract principles to concrete practices, and keep it under 300 lines.
- Move task-specific or tool-specific workflows into skills, commands, or project-level documentation.
- Limit the contents of this file to guidance that broadly applies across most repositories.
