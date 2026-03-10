---
name: pr
description: Generate a PR description and create a pull request via gh CLI.
argument-hint: "[optional base branch, e.g. main]"
model: haiku
---

Use the `pr-writer` agent to analyze the current branch's commits and diff against the base branch, generate a clear PR title and description, and create the pull request using `gh pr create`.

If the user provided a base branch as an argument, use that instead of auto-detecting it.

Push the branch if it hasn't been pushed yet. After creating the PR, output the URL.
