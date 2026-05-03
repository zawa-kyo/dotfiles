---
name: review-essential-code
description: Review code changes for bugs, regressions, missing tests, and whether the implementation is simple, essential, and maintainable rather than a short-term workaround. Use when the user asks for a code review, says "レビューして", wants review of AI-generated fixes or implementations, or asks whether a change is overcomplicated, ad hoc, brittle, or masking the real problem.
---

# Review Essential Code

## Overview

Review changes with the normal code-review lens first: correctness, regressions, edge cases, security, performance, and test coverage. Then add an explicit simplicity lens: whether the code solves the root problem in the local design idiom, or merely patches symptoms with special cases, duplicated logic, broad guards, or needless abstraction.

## Workflow

1. Identify the review target from the user request. If no target is named, inspect the current Git diff, including staged and unstaged changes separately unless the user specifies staged-only or a narrower target.
2. Read enough surrounding code to understand the existing design, invariants, public contracts, and local style. Do not judge simplicity without context.
3. Review for concrete correctness risks first: bugs, regressions, missing edge cases, broken API contracts, data loss, security issues, performance problems, and missing or weak tests.
4. Review for essential design next:
   - Does the change address the root cause, or only suppress the observed failure?
   - Does it preserve existing invariants instead of adding scattered exceptions?
   - Does it remove accidental complexity, or add flags, branches, retries, catches, sleeps, casts, globals, or duplicated logic to force tests green?
   - Is the abstraction justified by real reuse or complexity reduction?
   - Is the behavior clear at the call site and easy for the next maintainer to reason about?
5. Prefer findings that cite specific lines and concrete failure modes. Avoid style nits unless they affect maintainability or hide a real risk.
6. If the implementation is simple and sound, say so clearly. Do not invent findings to satisfy the review format.

## Workaround Smells

Treat these as prompts for deeper review, not automatic defects:

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

Do not rewrite the code unless the user explicitly asks for fixes. The review output should help the user decide what to change and why.
