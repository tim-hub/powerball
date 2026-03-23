---
name: commit
description: This skill should be used when the user asks to "commit changes", "commit my work", "make a commit", "stage and commit", or wants to save progress with a git commit. Stages relative changes and commits with an auto-generated conventional commit message.
argument-hint: "[optional context or hint for the commit message]"
user-invocable: true
allowed-tools: Bash, Read
context: fork
model: haiku
agent: powerball-core:junior
---

Analyze what has changed, write a precise conventional commit message, and commit — without asking for confirmation.

If the user provided an argument, treat it as a hint or context for the commit message (e.g. a ticket number, feature name, or description to incorporate).

## Process

1. Run `git status` to see all changed, untracked, and staged files.
2. Run `git diff HEAD` (or `git diff` + `git diff --cached`) to understand the actual changes.
3. Analyze the diff to determine:
   - The primary type of change: `feat`, `fix`, `refactor`, `docs`, `chore`, `test`, `style`, `perf`, `ci`, or `build`
   - A concise scope (optional) — the module, file, or area affected
   - A short imperative summary (under 72 chars) describing WHAT changed and WHY
4. Stage everything with `git add -A`.
5. Commit with the generated message.
6. Push to remote only if the user explicitly asked to push.

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
- Body only when the summary alone would be unclear

## Type Selection Guide

- `feat` — new capability or behavior visible to the user
- `fix` — corrects a bug or broken behavior
- `refactor` — code restructure with no behavior change
- `docs` — documentation only
- `chore` — tooling, deps, config, build
- `test` — adding or updating tests
- `style` — formatting, whitespace, no logic change
- `perf` — performance improvement
- `ci` — CI/CD pipeline changes

## Edge Cases

- Nothing to commit: Report `git status` and stop.
- Already-staged files exist: Stage all remaining changes too (`git add -A` covers both).
- Massive diff spanning many files: Use a broader type (`chore` or `refactor`) with a body summarizing the scope.
- Sensitive files (`.env`, credentials): Do NOT commit them. Warn the user and stop.

After committing, confirm with the commit hash and message so the user can see what was saved.
