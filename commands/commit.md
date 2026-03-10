---
name: commit
description: Stage all changes and commit with an auto-generated conventional commit message.
argument-hint: "[optional context or hint for the commit message]"
---

Use the `smart-commit` agent to stage all changes in the current git repository and commit them with a precise conventional commit message.

If the user provided an argument, treat it as a hint or context for the commit message (e.g. a ticket number, feature name, or description to incorporate).

Do not ask for confirmation — analyze the diff, generate the message, and commit immediately.
