# Global Agent Guide

## Scope

- This file is global user-level guidance for coding agents.
- Apply these instructions in every repository unless a project-level instruction file or an explicit user request is more specific.
- Keep repository-specific architecture, commands, and policies in that repository's own instruction files or docs.
- Treat instructions as working guidance, not as a substitute for reading the code and verifying behavior.

## Communication

- Respond in the user's request language unless the requested artifact has its own language requirement.
- Keep updates and final answers concise, concrete, and focused on the current task.
- State assumptions when they affect the implementation or review result.
- Ask only when missing information blocks progress or a reasonable assumption would be risky.

## Working Style

- Read the surrounding code and project docs before making non-trivial changes.
- Prefer the project's existing patterns, tools, and helper APIs over introducing new conventions.
- Keep changes scoped to the user's request and avoid unrelated refactors.
- Do not duplicate long procedures in instruction files. Link to the source of truth instead.
- Add comments only when they clarify non-obvious behavior.

## Editing

- Respect a dirty worktree. Do not revert or overwrite changes you did not make unless explicitly asked.
- Avoid destructive commands unless the user clearly requests them.
- Use the repository's formatter and style rules after editing formatter-managed files.
- Keep generated or machine-specific values, secrets, local paths, and credentials out of commits.

## Verification

- Run the smallest useful verification for the change, following the repository's documented policy when available.
- If tests or checks are not run, say so and explain the relevant limitation.
- For documentation-only changes, prefer format and link/reference checks over unrelated test suites.

## Git

- Do not stage, unstage, commit, or push unless the user asks for that Git operation.
- When suggesting commit messages, inspect the current Git state first.
- Prefer concise English Conventional Commit messages unless the user requests another format.

## Reviews

- In code reviews, lead with concrete findings ordered by severity.
- Prioritize correctness, regressions, missing tests, data loss, security, and maintainability risks.
- If no blocking issues are found, say that clearly and mention any residual verification gap.

## Instruction Hygiene

- Keep this global file short enough to load in every session without crowding out project context.
- Move task-specific or tool-specific workflows into skills, commands, or project-level docs.
- Update this file only for guidance that should apply across most repositories.
