---
name: solve
description: Fix a GitHub issue by number or URL.
argument-hint: "<issue number, URL>"
disable-model-invocation: true
model: sonnet
---

Determine which skill to use based on what the user provided:

- If the input is a GitHub issue number, URL, or reference (e.g. `42`, `#7`, a GitHub URL), use the `fix-issue` skill with `$ARGUMENTS`.
