# Get-Started Skill Interaction Refactor Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Move the "file exists → ask to override" interaction logic from shell scripts into SKILL.md so Claude handles confirmation via AskUserQuestion, eliminating the non-interactive `read` failures.

**Architecture:** SKILL.md instructs Claude to check file existence and use AskUserQuestion before calling each setup script. The two scripts (`init-claude-md.sh`, `init-statusline.sh`) are simplified to unconditional executors — no interactive prompts.

**Tech Stack:** Bash, SKILL.md (Claude skill format with YAML frontmatter)

---

## Background

`init-statusline.sh` has `set -e` at the top. When Claude runs it in a non-interactive shell, `read -r -p "..."` receives EOF and exits with code 1. `set -e` causes the script to abort before doing any work. `init-claude-md.sh` has the same pattern but lacks `set -e`, so it silently skips instead of crashing — still wrong behavior.

**Files to change:**
- `skills/get-started/SKILL.md`
- `skills/get-started/scripts/init-claude-md.sh`
- `skills/get-started/scripts/init-statusline.sh`

---

### Task 1: Simplify `init-claude-md.sh`

**Files:**
- Modify: `skills/get-started/scripts/init-claude-md.sh`

**Step 1: Read the current file**

Open `skills/get-started/scripts/init-claude-md.sh`. The current content:

```bash
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/../templates/CLAUDE.md"
DEST="$HOME/.claude/CLAUDE.md"

if [ -f "$DEST" ]; then
  read -r -p "~/.claude/CLAUDE.md already exists. Override? (y/N): " answer
  if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    cp "$SOURCE" "$DEST"
    echo "  ✓ Overridden: $DEST"
  else
    echo "  Skipped: $DEST"
  fi
else
  cp "$SOURCE" "$DEST"
  echo "  ✓ Installed: $DEST"
fi
```

**Step 2: Replace with unconditional copy**

Replace the entire file content with:

```bash
#!/bin/bash
# Copy template CLAUDE.md to ~/.claude/CLAUDE.md
# Unconditional — caller (SKILL.md) handles existence check and user confirmation.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/../templates/CLAUDE.md"
DEST="$HOME/.claude/CLAUDE.md"

cp "$SOURCE" "$DEST"
echo "  ✓ Installed: $DEST"
```

**Step 3: Verify the script runs cleanly**

```bash
bash skills/get-started/scripts/init-claude-md.sh
```

Expected output: `  ✓ Installed: /Users/<you>/.claude/CLAUDE.md`

**Step 4: Commit**

```bash
git add skills/get-started/scripts/init-claude-md.sh
git commit -m "refactor(get-started): remove interactive read from init-claude-md.sh"
```

---

### Task 2: Simplify `init-statusline.sh`

**Files:**
- Modify: `skills/get-started/scripts/init-statusline.sh`

**Step 1: Read the current file**

Open `skills/get-started/scripts/init-statusline.sh`. The section to remove is lines 13–27:

```bash
# Copy the statusline script
if [ -f "$DEST" ]; then
  read -r -p "statusline-command.sh already exists. Override? (y/N): " answer
  if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    cp "$SOURCE" "$DEST"
    chmod +x "$DEST"
    echo "  ✓ Overridden: $DEST"
  else
    echo "  Skipped: $DEST"
  fi
else
  cp "$SOURCE" "$DEST"
  chmod +x "$DEST"
  echo "  ✓ Installed: $DEST"
fi
```

**Step 2: Replace with unconditional copy**

Replace the entire file content with:

```bash
#!/bin/bash
# Initialize Claude Code status line
# Copies statusline-command.sh to ~/.claude/ and configures settings.json
# Unconditional — caller (SKILL.md) handles existence check and user confirmation.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SOURCE="$SCRIPT_DIR/powerball-statusline-command.sh"
DEST="$CLAUDE_DIR/statusline-command.sh"
SETTINGS="$CLAUDE_DIR/settings.json"

# Copy the statusline script
cp "$SOURCE" "$DEST"
chmod +x "$DEST"
echo "  ✓ Installed: $DEST"

# Update settings.json
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
fi

UPDATED=$(jq '. + {"statusLine": {"type": "command", "command": "bash ~/.claude/statusline-command.sh"}}' "$SETTINGS")
echo "$UPDATED" > "$SETTINGS"
echo "  ✓ statusLine configured in settings.json"
```

**Step 3: Verify the script runs cleanly**

```bash
bash skills/get-started/scripts/init-statusline.sh
```

Expected output:
```
  ✓ Installed: /Users/<you>/.claude/statusline-command.sh
  ✓ statusLine configured in settings.json
```

**Step 4: Commit**

```bash
git add skills/get-started/scripts/init-statusline.sh
git commit -m "refactor(get-started): remove interactive read from init-statusline.sh"
```

---

### Task 3: Update SKILL.md with existence checks and AskUserQuestion

**Files:**
- Modify: `skills/get-started/SKILL.md`

**Step 1: Read the current SKILL.md**

Open `skills/get-started/SKILL.md`. The body currently reads:

```
Run the following in order:

- Set up CLAUDE.md:
```bash
bash "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/init-claude-md.sh"
```

- Set up statusline:
```bash
bash "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/init-statusline.sh"
```

- Set up plugins:
```bash
bash "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/set-up-plugins.sh"
```

Report the output of each step, then stop.
```

**Step 2: Replace the body with the new interaction-aware instructions**

Replace everything after the closing `---` of the YAML frontmatter with:

````markdown
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
````

**Step 3: Verify the frontmatter is intact**

Check the final file looks like this at the top:

```yaml
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
```

**Step 4: Commit**

```bash
git add skills/get-started/SKILL.md
git commit -m "feat(get-started): move file-exists checks and confirmation to skill"
```

---

### Task 4: End-to-end smoke test

**Step 1: Simulate a fresh run (files missing)**

Temporarily rename the existing files:

```bash
mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.bak
mv ~/.claude/statusline-command.sh ~/.claude/statusline-command.sh.bak
```

**Step 2: Run the skill**

Invoke `/powerball:get-started` in Claude Code. Expected behavior:
- Both files are "missing" → scripts run directly → no AskUserQuestion prompts
- Both report `✓ Installed`

**Step 3: Restore and simulate override scenario**

```bash
mv ~/.claude/CLAUDE.md.bak ~/.claude/CLAUDE.md
mv ~/.claude/statusline-command.sh.bak ~/.claude/statusline-command.sh
```

Invoke `/powerball:get-started` again. Expected behavior:
- Both files are "exists" → AskUserQuestion prompts appear for each
- Choosing "No, skip" → reports `Skipped`
- Choosing "Yes, override" → scripts run and report `✓ Installed`
