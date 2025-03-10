---
name: get-started
description: Initialize claude code settings — set up statusline, global CLAUDE.md and install plugins. Triggered by requests like "set up claude code", "initialize plugins", "get started", or "run setup".
model: haiku
tools:
  allow:
    - Bash
  deny:
    - WebFetch
    - Fetch
hooks:
  Stop:
    - matcher: "*"
      hooks:
        - type: command
          command: bash "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/done.sh"
          timeout: 120
---

Run the following steps in order. For each step, check if the file already exists before running the script.

## Step 1: Set up CLAUDE.md

Check if `~/.claude/CLAUDE.md` already exists:

```bash
test -f ~/.claude/CLAUDE.md && echo "exists" || echo "missing"
```

- If **missing**: run the script directly:
  ```bash
  bash "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/init-claude-md.sh"
  ```

- If **exists**: use `AskUserQuestion` to ask:
  > "~/.claude/CLAUDE.md already exists. Override it with the powerball template?"
  - Options: "Yes, override" / "No, skip"
  - If Yes: run the script
  - If No: report `  Skipped: ~/.claude/CLAUDE.md`

## Step 2: Set up statusline

Check if `~/.claude/statusline-command.sh` already exists:

```bash
test -f ~/.claude/statusline-command.sh && echo "exists" || echo "missing"
```

- If **missing**: run the script directly:
  ```bash
  bash "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/init-statusline.sh"
  ```

- If **exists**: use `AskUserQuestion` to ask:
  > "~/.claude/statusline-command.sh already exists. Override it with the powerball statusline?"
  - Options: "Yes, override" / "No, skip"
  - If Yes: run the script
  - If No: report `  Skipped: ~/.claude/statusline-command.sh`

## Step 3: Set up plugins

```bash
bash "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/set-up-plugins.sh"
```

Report the output of each step, then stop.
