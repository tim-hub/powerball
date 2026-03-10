---
name: fix-problem
description: Use when the user describes a problem, bug, or feature to fix without a GitHub issue number. Examples: "fix the login crash", "the dropdown doesn't close on outside click", "users can't upload files larger than 1MB".
disable-model-invocation: true
model: inherit
---
Analyze and fix the problem described: $ARGUMENTS.

1. Understand the problem from the description: "$ARGUMENTS". If it is unclear, ask the user one focused clarifying question before proceeding.
2. Search the codebase for relevant files related to the problem.
3. Create and checkout a new branch: `git checkout -b fix/<short-slug>` (derive slug from the problem description).
4. Identify the root cause by reading relevant files.
5. Implement the necessary changes to fix the problem.
6. Write and run tests to verify the fix. Discover the test runner from `package.json`, `Makefile`, or project conventions.
7. Ensure code passes linting and type checking. Discover the linter from project config if not obvious.
8. Use the `review` command to review all changes, address any feedback, and ensure the code meets quality standards.
9. Use the `smart-commit` agent to stage and commit the changes.
10. Use the `pr-writer` agent to push the branch and open a PR. Describe the fix in the PR body based on the original problem description.
