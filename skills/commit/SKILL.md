---
name: commit
description: Commit changes manually.
argument-hint: "[optional context or hint for the commit message]"
model: haiku
allowed-tools: Agent, Skill, Bash(git *), Bash(gh *), Read
context: fork
agent: powerball:smart-committer
user-invocable: true
disable-model-invocation: true  
---

Use the `smart-committer` agent to stage relative changes in the current git repository and commit them with a precise conventional commit message.

If the user provided an argument, treat it as a hint or context for the commit message (e.g. a ticket number, feature name, or description to incorporate).

Do not ask for confirmation — analyze the diff, generate the message, and commit immediately.
