---
name: optimize-skill-reminder
description: This skill should be used when the user asks about the optimize-skill PostToolUse hook, wants to understand how it works, or needs to disable it. The hook itself runs automatically via hooks.json — no installation required.
user-invocable: true
model: haiku
allowed-tools: Bash, Read, Edit
---

The optimize-skill hook fires automatically after any `Edit` or `Write` on a skill file. It lives in `personal/hooks/hooks.json` under `PostToolUse` as a `command` type, running `scripts/hook.py`.

## What it does

When a file inside a `skills/<name>/` directory is edited, a Haiku agent checks the path and — if it matches — invokes `/optimize-skill` on the skill directory and applies auto-fixes. Files in `/plugins/cache/` and non-skill paths are silently ignored.

## To disable

Edit `personal/hooks/hooks.json` and remove the `Edit|Write` agent entry from the `PostToolUse` array.

## To inspect the hook

```bash
cat "$CLAUDE_PLUGIN_ROOT/hooks/hooks.json"
```

## Prerequisites

The `/optimize-skill` skill must be installed from the marketplace for the hook's invocations to resolve.
