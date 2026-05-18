---
name: push
description: Push the current branch to remote, setting upstream if needed. Use when the user asks to push, push to remote, push changes, or sync with remote.
argument-hint: "[optional: remote name, defaults to origin]"
user-invocable: true
allowed-tools: Bash
context: fork
model: haiku
---

Push the current branch to its remote.

## Steps

1. `git status` — if uncommitted changes exist, warn and stop.
2. No upstream → `git push -u origin <branch>`, has upstream → `git push`.
3. Confirm the remote branch and commits sent.

## Guards

- Already up to date: say so and stop.
- Rejected (non-fast-forward): report error, suggest `git pull --rebase`, do not force push.
- Detached HEAD: warn and stop.
