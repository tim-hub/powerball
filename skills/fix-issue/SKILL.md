---
name: fix-issue
description: |
    Use when the user asks to fix, resolve, or address a GitHub issue by number or URL. Examples: "fix issue 42", "resolve #7", "address the bug in issue 15".
disable-model-invocation: true
model: inherit
---
Analyze and fix the GitHub issue: $ARGUMENTS.

1. Use `gh issue view $ARGUMENTS` to get the issue details. If the issue is not found or `gh` is not authenticated, stop and report the error.
2. Understand the problem described in the issue.
3. Create and checkout a new branch: `git checkout -b fix/<issue-number>-<short-slug>` (derive slug from the issue title).
4. Search the codebase for relevant files.
5. Implement the necessary changes to fix the issue.
6. Write and run tests to verify the fix. Discover the test runner from `package.json`, `Makefile`, or project conventions.
7. Ensure code passes linting and type checking. Discover the linter from project config if not obvious.
8. Use the `review` command to review all changes, address any feedback, and ensure the code meets quality standards, if unsure of how to implement the fix, ask user for guidance or clarification on the issue.
9. Use the `smart-committer` agent to stage and commit the changes.
10. Use the `pr-writing` skill to push the branch and open a PR. Reference the issue number in the PR body (e.g. `Closes #$ARGUMENTS`).
