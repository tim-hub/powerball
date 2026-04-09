---
name: archive
description: Use when the user asks to "archive", "archive specs", "clean up specs", "move to archive", or wants to move completed spec directories out of the active workspace.
user-invocable: true
argument-hint: "[spec name to archive, or leave blank to pick from existing specs]"
model: haiku
---

Move completed spec directories from `.powerball/specs/` to `.powerball/archive/`.

## Step 1: Select spec to archive

1. If the user provided an argument, find the matching directory under `.powerball/specs/` (match by name suffix after the date prefix).
2. If no argument, list directories under `.powerball/specs/` and ask the user which to archive.
3. If `.powerball/specs/` is empty, tell the user there's nothing to archive and stop.

## Step 2: Verify completion

Before archiving, check `checklist.md` in the selected spec directory:
- If all checkpoints are `[x]`, proceed.
- If any are `[ ]`, warn the user which checkpoints are incomplete and ask whether to archive anyway or go back and finish.
- If no `checklist.md` exists, proceed without warning.

## Step 3: Move to archive

1. Create `.powerball/archive/` if it doesn't exist.
2. Move the selected directory: `.powerball/specs/YYYY-MM-DD-{{name}}/` to `.powerball/archive/YYYY-MM-DD-{{name}}/`.
3. If a directory with the same name already exists in archive, ask the user whether to overwrite, rename with a suffix, or cancel.

## Step 4: Report

Tell the user:
- What was archived
- Where it was moved to
- How many spec directories remain in `.powerball/specs/`
