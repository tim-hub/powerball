---
name: push
description: Push the current branch to the remote, setting upstream tracking if needed. Use when the user asks to push, push to remote, push changes, or sync with remote.
argument-hint: "[optional: remote name, defaults to origin]"
user-invocable: true
allowed-tools: Bash
context: fork
model: haiku
---

Push the current branch to its remote, then confirm what was pushed.

## Process

1. Run `git status` to check for uncommitted changes. If there are any, warn the user — do not commit them automatically.
2. Run `git branch --show-current` to get the branch name.
3. Check if the branch has an upstream: `git rev-parse --abbrev-ref @{u}` (exit code non-zero = no upstream yet).
4. Push:
   - No upstream: `git push -u origin <branch>`
   - Has upstream: `git push`
5. Report the remote URL and the number of commits pushed (`git log @{u}..HEAD --oneline` before pushing gives the count).

## Edge Cases

- Nothing to push (already up to date): say so and stop.
- Rejected push (non-fast-forward): report the error, suggest `git pull --rebase` to reconcile, and stop — do not force push.
- Detached HEAD: warn the user and stop.

After pushing, confirm with the remote branch name and the commits that were sent.
