---
name: solve
description: Fix a GitHub issue by number or URL, or describe a problem/bug to fix.
argument-hint: "<issue number, URL, or problem description>"
disable-model-invocation: true
model: sonnet
---

Determine which skill to use based on what the user provided:

- If the input is a GitHub issue number, URL, or reference (e.g. `42`, `#7`, a GitHub URL), use the `fix-issue` skill with `$ARGUMENTS`.
- If the input is a description of a problem (e.g. "the login crashes", "dropdown doesn't close"), use the `fix-problem` skill with `$ARGUMENTS`.
