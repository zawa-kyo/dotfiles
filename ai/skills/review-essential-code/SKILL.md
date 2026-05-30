---
name: review-essential-code
description: Review code changes for bugs, regressions, missing tests, and whether the implementation is simple, essential, and maintainable rather than a short-term workaround. Use when the user asks for a code review, says "レビューして", wants review of AI-generated fixes or implementations, or asks whether a change is overcomplicated, ad hoc, brittle, or masking the real problem.
---

# Review Essential Code

## Language Versions

This file and `SKILL-ja.md` are documents that describe the same skill. When changing either file, update the other in the same change so the English and Japanese versions stay aligned while remaining natural in each language.

## Overview

Review changes with the normal code-review lens first: correctness, regressions, edge cases, security, performance, and test coverage. Then add simplicity as an additional important lens: whether the code solves the root problem in the local design idiom, or merely patches symptoms with special cases, duplicated logic, broad guards, needless abstraction, and similar workarounds.

## Workflow

1. Identify the review target from the user request. If no target is named, inspect the current Git diff, including staged and unstaged changes separately unless the user specifies staged-only or a narrower target.
2. Read enough surrounding code to understand the existing design, invariants, public contracts, and local style. Do not judge simplicity without context.
3. Do not modify the worktree or index while reviewing unless the user explicitly asks for fixes. In particular, do not run `git add`, `git restore --staged`, formatting, or other commands that stage, unstage, rewrite, or normalize the reviewed diff.
4. Conduct a risk review first: bugs, regressions, missing edge cases, broken API contracts, data loss, security issues, performance problems, missing or weak tests, style, and similar concerns.
5. Review for essential design next:
   - Does the change address the root cause, or is it only suppressing the observed failure?
   - Does it preserve existing invariants, or does it add scattered exceptions?
   - Does it remove accidental complexity, or is it merely forcing tests green by adding flags, branches, retries, catches, sleeps, casts, globals, or duplicated logic?
   - Is the abstraction justified by real reuse or complexity reduction?
   - Is the behavior clear at the call site and easy for developers or maintainers other than the implementer to reason about?
6. Prefer findings that cite specific code locations and explain why they are problems. Avoid style nits unless they affect maintainability or hide a real risk.
7. When a finding depends on an implied contract, state the assumption explicitly after the findings. If the assumption is weak enough that the risk is only hypothetical, downgrade it to an open question instead of presenting it as a finding.
8. If the implementation is simple and sound, say so clearly. Do not invent findings to satisfy the review format.

## Severity and Confidence

- Calibrate severity by user-visible impact and likelihood, not by how suspicious the code looks. Data loss, security exposure, broken public contracts, and crashes in normal use are usually high importance. Missing tests or maintainability concerns should be treated as lower priority unless they enable a concrete regression.
- If the reviewed material is a conceptual diff, excerpt, or otherwise incomplete, say what was not verified when it affects confidence. Even with incomplete context, do not hold back a finding when you can explain how the problem occurs. However, make the assumption that the finding depends on explicit.
- Suggest the smallest fix first. Prefer restoring the local invariant or boundary that owns the behavior over prescribing a large rewrite. However, when the essential problem would remain, do not hesitate to suggest a larger fix.

## Workaround Smells

Treat these as prompts for deeper review, not automatic defects.

- A broad `try/catch`, `return null`, default value, or guard that hides invalid state without explaining why it is valid to continue.
- A hard-coded special case for the failing input instead of a general rule already present in nearby code.
- Duplicated transformation or validation logic instead of reusing the domain boundary that owns it.
- New configuration, flags, or optional parameters that only exist to thread around one failing path.
- Timing-based fixes, retries, sleeps, cache clears, or order dependencies without a proven concurrency or lifecycle model.
- Type assertions, unchecked casts, or relaxed schemas that make the compiler or validator stop complaining while weakening the contract.
- Test changes that reduce assertions, skip behavior, or bless the new output without proving the intended behavior.

## Output

Use the standard code-review shape:

- Lead with findings, ordered by severity.
- For each finding, include file and line reference, severity, the concrete risk, and the smallest directionally correct fix.
- Separate "correctness findings" from "simplicity/design findings" only when that makes the review easier to scan.
- Include open questions or assumptions after findings.
- State any verification that was not run when it affects confidence in the review.
- End with a brief summary only after findings.
- Write the review in the user's request language unless they explicitly ask for another language.

When no issues are found, say that no blocking issues were found and mention any residual test or context gaps.

Do not rewrite the code unless the user explicitly asks for fixes. The review output should explain the background and reasons sufficiently and clearly so it helps the user understand why.
