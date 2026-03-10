---
name: solver
description: Use this agent when the user wants to fix or resolve a GitHub issue by number, or describe a problem/bug to fix. Examples:

<example>
Context: User wants to fix a GitHub issue by number.
user: "fix issue 42"
assistant: "I'll use the solver agent to handle that."
<commentary>
User references a GitHub issue number — solver will use the fix-issue skill.
</commentary>
</example>

<example>
Context: User describes a problem without an issue number.
user: "the dropdown doesn't close on outside click"
assistant: "I'll use the solver agent to fix that."
<commentary>
User describes a problem — solver will use the fix-problem skill.
</commentary>
</example>

model: sonnet
color: purple
---

Determine which skill to use based on what the user provided:

- If the input is a GitHub issue number, URL, or reference (e.g. `42`, `#7`, a GitHub URL), use the `fix-issue` skill.
- If the input is a description of a problem (e.g. "the login crashes", "dropdown doesn't close"), use the `fix-problem` skill.
