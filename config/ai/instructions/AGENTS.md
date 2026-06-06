# Global Agent Guide

## Core Principles

- This file provides global user-level guidance for coding agents.
- When a project-specific instruction file or a user request is more specific, follow that instead.
- Use the following priority order:
  - Follow explicit user requests first.
  - Then follow the nearest project or directory instruction file.
  - Treat this global file as defaults unless more specific guidance overrides them.
  - When instructions conflict, state the conflict and follow the more specific instruction.
- Keep changes scoped to the user's request and avoid unrelated refactors.
- Prefer the project's existing patterns, tools, and helper APIs over introducing new conventions.

## Interaction

- Respond in the user's request language unless the requested artifact has its own language requirement.
  - Reply in Japanese when the user asks in Japanese, and in English when the user asks in English.
- Keep updates and final answers concise, concrete, and limited to the current task.
- State assumptions that affect the implementation or review result, and do not leave them implicit.
- Ask when missing information blocks progress or when guessing would be risky.

## Implementation Practice

- Read the surrounding code and project docs before making non-trivial changes.
- Make code show the processing flow, and make tests show behavior from the user's perspective.
- Use commit bodies or comments to explain Why or Why not when the context matters.
- Add comments only when they clarify behavior that is hard to infer from the code itself.
- Use the repository's formatter and style rules after editing formatter-managed files.
- If tests or checks are not run, say why and describe the remaining limitation.

## Safety and Ownership

- Ask before destructive operations, broad filesystem changes, external publication, or actions that may spend money.
- If the task requires installing dependencies, changing global tools, or modifying machine-level configuration, ask the user before doing it.
- Do not use destructive commands unless the user clearly asks for them.
- Do not stage, unstage, commit, push, or publish changes unless the user asks for that Git operation.
- Do not revert or overwrite changes you did not make unless explicitly asked.
- Keep generated values, machine-specific values, secrets, local paths, and credentials out of commits.

## Review and Reporting

- In code reviews, lead with concrete findings ordered by severity.
- Prioritize quality issues, regressions, missing tests, data loss, security, and maintainability risks.
- If no blocking issues are found, say that clearly and mention any residual verification gap.
- Summarize what changed, what was verified, and any remaining risk.
- Mention files changed when that helps the user review the work.
- Do not claim tests passed unless they were actually run.

## Prose and Maintenance

- When writing Japanese, think in Japanese instead of drafting in English and translating. Translation-shaped prose often overuses katakana or keeps English sentence patterns.
- Japanese particles are important. Do not omit particles except in intentional quotations or code snippets.
- When editing existing files, check the surrounding prose style and choose polite or plain Japanese appropriately.
- Do not force a Japanese replacement for domain terms that are common in Japanese, lack a clear Japanese equivalent, or would become less precise when translated.
- Use bold text sparingly, mainly for first definitions or note labels.
- Prefer prose when a long bullet list would read mechanically.
- Introduce technical terms with a short explanation instead of assuming the reader knows them.
- Use document titles or concept names when file names, paths, or code identifiers interrupt the prose.
- Avoid overusing callout boxes or note blocks when the point fits in the surrounding prose.
- Organize this file from abstract principles to concrete practices, and keep it under 300 lines.
- Move task-specific or tool-specific workflows into skills, commands, or project-level docs.
- Keep only guidance that should apply across most repositories in this file.
