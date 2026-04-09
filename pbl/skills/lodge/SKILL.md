---
name: lodge
description: Use when the user asks to "lodge", "lodge specs", "archive", "clean up specs", "move to lodge", or wants to move completed spec directories out of the active workspace.
user-invocable: true
argument-hint: "[spec name to lodge, or leave blank to pick from existing specs]"
model: haiku
---

Move completed spec directories from `.powerball/specs/` to `.powerball/lodge/`, after verifying specs and code are in sync.

## Step 0: Select spec to lodge

1. If the user provided an argument, find the matching directory under `.powerball/specs/` (match by name suffix after the date prefix).
2. If no argument, list directories under `.powerball/specs/` and ask the user which to lodge.
3. If `.powerball/specs/` is empty, tell the user there's nothing to lodge and stop.

## Step 1: Sync specs with code

Invoke the `sync-specs` skill with the selected spec directory. This compares spec artifacts against actual code changes and surfaces any drift. If drift is found, the user decides whether to update specs, revert code, or accept drift before proceeding.

Only continue to Step 2 after sync-specs completes and any drift is resolved.

## Step 2: Verify completion

Before lodging, check both `checklist.md` and `tasks.md` in the selected spec directory:

**Checklist check:**
- If all checkpoints are `[x]`, proceed.
- If any are `[ ]`, warn the user which checkpoints are incomplete and ask whether to lodge anyway or go back and finish.
- If no `checklist.md` exists, proceed without warning.

**Unresolved review tasks check:**
- Scan `tasks.md` for any `[ ]` tasks with "Review fix:" prefix — these are unresolved code review findings.
- If found, warn the user: "There are N unresolved code review fixes." List them and ask whether to lodge anyway or go back and fix.
- If no `tasks.md` exists, proceed without warning.

## Step 3: Move to lodge

1. Create `.powerball/lodge/` if it doesn't exist.
2. Move the selected directory: `.powerball/specs/YYYY-MM-DD-{{name}}/` to `.powerball/lodge/YYYY-MM-DD-{{name}}/`.
3. If a directory with the same name already exists in lodge, ask the user whether to overwrite, rename with a suffix, or cancel.

## Step 4: Report

Tell the user:
- What was lodged
- Where it was moved to
- How many spec directories remain in `.powerball/specs/`
