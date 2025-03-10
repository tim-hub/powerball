# Design: Move Interaction Logic from Scripts to Skill

**Date:** 2026-03-11
**Status:** Approved

## Problem

`init-claude-md.sh` and `init-statusline.sh` both use `read -r -p` to interactively confirm before overwriting existing files. When invoked by Claude Code (non-interactive shell, no TTY), `read` receives EOF and exits with code 1. Combined with `set -e`, the script aborts silently before doing any work.

## Solution: Option A — Skill owns interaction, scripts become pure executors

**Principle:** Claude (the skill) handles all user-facing decisions. Shell scripts handle all file system operations. The two concerns are cleanly separated.

## Design

### SKILL.md changes

For each of the two interactive steps (CLAUDE.md and statusline), the skill instructs Claude to:

1. Check if the destination file exists using a Bash one-liner
2. If it exists, use `AskUserQuestion` to ask the user whether to override
3. Based on the answer, either call the script or report "Skipped"

The `set-up-plugins.sh` step is unchanged — it has no interactive prompt.

### Script changes

Both `init-claude-md.sh` and `init-statusline.sh` are simplified:

- Remove the `if [ -f "$DEST" ]; then read ...; fi` block entirely
- Scripts become unconditional: always copy and configure
- `set -e` stays — no `read` means no spurious failure

### Data flow

```
SKILL.md (Claude)
  ├── check ~/.claude/CLAUDE.md exists?
  │     └── AskUserQuestion → yes → call init-claude-md.sh
  │                         → no  → skip
  ├── check ~/.claude/statusline-command.sh exists?
  │     └── AskUserQuestion → yes → call init-statusline.sh
  │                         → no  → skip
  └── call set-up-plugins.sh (unchanged)
```

### Trade-offs accepted

- Scripts lose standalone "safe" behavior (they always overwrite when called directly)
- Acceptable: these are plugin-internal scripts, not designed for standalone use

## Files to Change

| File | Change |
|------|--------|
| `skills/get-started/SKILL.md` | Add existence checks + AskUserQuestion before each script call |
| `skills/get-started/scripts/init-claude-md.sh` | Remove `if exists → read → skip/copy` block; always copy |
| `skills/get-started/scripts/init-statusline.sh` | Remove `if exists → read → skip/copy` block; always copy |
