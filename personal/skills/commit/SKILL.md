---
name: commit
description: Stage all relevant changes and commit with an auto-generated conventional commit message. Use when the user asks to commit changes, commit work, make a commit, or save progress.
argument-hint: "[optional context or hint for the commit message]"
user-invocable: true
allowed-tools: Bash, Read
context: fork
model: haiku
---

Stage and commit with a conventional commit message — no confirmation needed.

If an argument was provided, treat it as a hint for the message (ticket number, feature name, etc.).

## Steps

1. `git status` + `git diff HEAD` — if sensitive files appear (`.env`, credentials, keys), warn and stop.
2. Pick `type(scope): summary` — imperative mood, under 72 chars, body only when the why isn't obvious.
3. `git add -A` then commit.
4. Confirm with the commit hash and message.

## Types

`feat` · `fix` · `refactor` · `docs` · `chore` · `test` · `style` · `perf` · `ci` · `build` · `skill` (AI skill/prompt changes)

Nothing to commit? Report status and stop.
