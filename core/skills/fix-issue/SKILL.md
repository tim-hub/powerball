---
name: fix-issue
description: Automatically fix, resolve, or address a small issue, straightforward task or small feature request from a GitHub issue by number or URL. Examples: "fix issue 42", "resolve #7", "address the bug in issue 15".
argument-hint: "[issue number or URL]"
user-invocable: true
model: sonnet
disable-model-invocation: true
---

Automatically analyze and fix the GitHub issue: $ARGUMENTS.

1. Use `gh issue view $ARGUMENTS` to get the issue details. If the issue is not found or `gh` is not authenticated, stop and report the error.
2. Understand the problem described in the issue.
3. Search the codebase for relevant files.
4. Create and checkout a new branch: `git checkout -b fix/<issue-number>-<short-slug>` (derive slug from the issue title).
5. Use `superpowers:brainstorming` skill to outline a plan to fix the issue, including which files to modify and what changes to make, save it to `docs` folder. Follow recommended solution if needs confirmation from user before proceeding.
6. Use `superpowers:test-driven-development` skill to implement the necessary changes to fix the issue. Write and run tests to verify the fix. Discover the test runner from `package.json`, `Makefile`, or project conventions.
7. Ensure code passes linting and type checking. Discover the linter from project config if not obvious.
8. Use the `review` skill to review all changes, address any feedback, and ensure the code meets quality standards. If unsure of how to implement the fix, ask user for guidance or clarification on the issue.
9. Use the `smart-committer` agent to stage and commit the changes.
10. Use the `gh` cli to push the branch and open a PR. Reference the issue number in the PR body (e.g. `Closes #$ARGUMENTS`).
