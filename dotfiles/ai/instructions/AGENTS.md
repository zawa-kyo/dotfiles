# Global Agent Guide

## Core Principles

- Follow explicit user requests first, then the nearest project- or directory-level instructions, falling back to this global guide.
- Keep changes scoped to the request; avoid unrelated refactoring.
- Prefer existing project patterns, tools, and helper APIs over introducing new conventions.
- Before making non-trivial changes, read surrounding code or prose and relevant project documentation to understand the existing structure.
- Proceed with minor, reversible improvements without confirmation. Ask before changing objectives, scope, costs, safety, user-visible behavior, or explicit constraints.

## Interaction

- Respond in the request language (e.g., Japanese for Japanese, English for English).
- Keep updates and answers concise, concrete, and focused on the task.
- Explicitly state assumptions that affect implementation or review.

## Implementation Practice

- Consult official documentation first when checking or configuring library, SDK, or tool behavior. Prefer recommended and maintained settings; propose workarounds only when no official path exists.
- Prioritize root-cause fixes over superficial patches. If a root-cause fix requires a substantially broader scope, explain the trade-offs and confirm before implementing.
- Add or update tests for affected behavior following the project's testing conventions. Explain if tests or checks are skipped.
- Follow the repository's formatter and style rules.
- Add comments only when the intent is difficult to infer directly from the code.

## Safety and Ownership

- Ask before performing destructive operations, broad filesystem changes, external publishing, or actions that incur costs or modify machine-level configuration.
- Ask before installing dependencies or modifying global tools.
- Do not stage, unstage, commit, push, or publish changes unless explicitly requested.
- Treat commands modifying the Git index as staging operations (`git add`, `git mv`, `git rm`, `git restore --staged`). When moving or deleting tracked files without a staging request, use filesystem operations (e.g., `mv`) and verify unstaged status with `git status --short`.
- Do not revert or overwrite unauthored changes unless requested.

## Running Commands That Access Secrets

- Before running commands that may use credentials (e.g., `gh auth status`), run `fnox list` (without `--values`) to check whether fnox manages the secret.
- If managed by fnox, run via `fnox exec -- <command>`.
- Never print, log, inspect, or write secrets to files or configuration unless explicitly requested.

## Review and Reporting

- Order findings by severity, prioritizing regressions, test gaps, data loss, security risks, and maintainability.
- Summarize changes, verification performed, and any residual risks.
- Do not claim tests passed unless they were actually executed.

## Prose and Japanese Writing

- When writing Japanese, refer to the `revise-japanese-writing` skill for tone, terminology, and notation (e.g., avoid translationese and unnecessary English mixing).
- Use semantic line breaks where they do not affect rendering.
- Avoid hardcoding sequence numbers in headings or prose where content may shift. Use Mermaid for complex diagrams.
- Keep this file general and concise. Move task- or tool-specific workflows into skills, commands, or project documentation.
