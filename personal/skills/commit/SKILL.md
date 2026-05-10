---
name: commit
description: Stage all relevant changes and commit with an auto-generated conventional commit message. Use when the user asks to commit changes, commit work, make a commit, or save progress.
argument-hint: "[optional context or hint for the commit message]"
user-invocable: true
allowed-tools: Bash
context: fork
model: haiku
---

Analyze what has changed, write a precise conventional commit message, and commit — without asking for confirmation.

If the user provided an argument, treat it as a hint or context for the commit message (e.g. a ticket number, feature name, or description to incorporate).

## Process

1. Run `git status` and `git diff HEAD` together to see all changes. **If any sensitive files** (`.env`, credentials, secrets, private keys) appear in the output, warn the user and stop — do not stage or commit them.
2. Analyze the diff to determine:
   - The primary type of change — see Type Selection Guide below
   - A concise scope (optional) — the module, file, or area affected
   - A short imperative summary (under 72 chars) describing WHAT changed
3. Stage changes with `git add -A`.
4. Commit with the generated message.
5. Push to remote only if the user explicitly asked to push.

## Conventional Commit Format

```
type(scope): short summary

Optional longer body explaining the why, not the what.
```

## Message Quality Rules

- Use imperative mood: "add", "fix", "remove" — not "added", "fixes", "removed"
- Summary under 72 characters
- No period at the end of the summary line
- If changes span multiple concerns, pick the dominant one for the type; mention others in body
- Body only when motivation or context isn't obvious from the summary

## Type Selection Guide

- `feat` — new capability or behavior visible to the user
- `fix` — corrects a bug or broken behavior
- `refactor` — code restructure with no behavior change
- `docs` — documentation only
- `chore` — tooling, config, build
- `test` — adding or updating tests
- `style` — formatting, whitespace, no logic change
- `perf` — performance improvement
- `ci` — CI/CD pipeline changes
- `build` — external dependency changes (package upgrades, lockfile bumps)
- `skill` — additions or updates to agent AI coding skills, prompts, or skill definitions

## Edge Cases

- Nothing to commit: report `git status` and stop.
- Already-staged files exist: `git add -A` will stage remaining changes too.
- Massive diff spanning many files: use a broader type (`chore` or `refactor`) with a body summarizing the scope.

After committing, confirm with the commit hash and message so the user can see what was saved.
