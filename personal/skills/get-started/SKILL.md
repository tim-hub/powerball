---
name: get-started
description: This skill should be used when the user asks to "set up claude code", "initialize plugins", "get started with powerball", or "run setup". Sets up global CLAUDE.md, statusline, Claude Code settings, and installs plugins.
model: haiku
allowed-tools: Bash, Read, Write, Edit
disable-model-invocation: true
user-invocable: true
argument-hint: "[all | claude.md | statusline | playwright | chub | skills | rules | settings | plugins]"
hooks:
  Stop:
    - matcher: "*"
      hooks:
        - type: command
          command: >
            test -f /tmp/.get-started-running &&
            rm /tmp/.get-started-running &&
            bash "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/done.sh"
          timeout: 120
---

The base directory for this skill is shown in the header when invoked (e.g. `/path/to/plugin/skills/get-started`). All script paths below use `<base-dir>/scripts/` — substitute the actual base directory path shown in the header.

## Arguments

This skill accepts optional arguments to run specific steps. With no arguments or `all`, every step runs.

| Argument       | Step(s)                          |
|----------------|----------------------------------|
| `all`          | Run all steps (default)          |
| `claude.md`    | Step 1 — Set up CLAUDE.md        |
| `statusline`   | Step 2 — Set up statusline       |
| `playwright`   | Step 3 — Install playwright-cli  |
| `chub`         | Step 4 — Install chub            |
| `skills`       | Step 5 — Upsert external skills  |
| `rules`        | Step 6 — Upsert rules            |
| `settings`     | Step 7 — Upsert Claude settings  |
| `plugins`      | Step 8 — Upsert plugins          |

Multiple arguments can be passed space-separated, e.g. `/get-started rules plugins settings`.

Parse the arguments from the skill invocation. If no arguments or `all`, run every step. Otherwise, run only the matching steps in order.

---

Before starting, create the sentinel file so the Stop hook knows this skill ran:

```bash
touch /tmp/.get-started-running
```

## Step 1: Set up CLAUDE.md

**Argument: `claude.md`**

Check if `~/.claude/CLAUDE.md` already exists:

```bash
test -f ~/.claude/CLAUDE.md && echo "exists" || echo "missing"
```

- If **missing**: run the script using the base directory from this skill's header:
  ```bash
  bash "<base-dir>/scripts/init-claude-md.sh"
  ```

- If **exists**: use `AskUserQuestion` to ask:
  > "~/.claude/CLAUDE.md already exists. Override it with the powerball template?"
  - Options: "Yes, override" / "No, skip"
  - If Yes: run the script
  - If No: report `  Skipped: ~/.claude/CLAUDE.md`

## Step 2: Set up statusline

**Argument: `statusline`**

Check if `~/.claude/statusline-command.sh` already exists:

```bash
test -f ~/.claude/statusline-command.sh && echo "exists" || echo "missing"
```

- If **missing**: copy the statusline script:
  ```bash
  bash "<base-dir>/scripts/init-statusline.sh"
  ```
  Then use the `statusline-setup` Agent to configure `~/.claude/settings.json` with the command `bash ~/.claude/statusline-command.sh`.

- If **exists**: use `AskUserQuestion` to ask:
  > "~/.claude/statusline-command.sh already exists. Override it with the powerball statusline?"
  - Options: "Yes, override" / "No, skip"
  - If Yes: run the script, then use the `statusline-setup` Agent to configure `~/.claude/settings.json`
  - If No: report `  Skipped: ~/.claude/statusline-command.sh`

## Step 3: Install playwright-cli skills

**Argument: `playwright`**

Check if `@playwright/cli` is already installed globally:

```bash
playwright-cli --version 2>/dev/null && echo "installed" || echo "missing"
```

- If **installed**: skip the install step, proceed directly to running:
  ```bash
  cd ~ && playwright-cli install --skills
  ```

- If **missing**: install it first, then install skills:
  ```bash
  pnpm install -g @playwright/cli@latest
  cd ~  && playwright-cli install --skills
  ```

## Step 4: Install chub and get-api-docs skill

**Argument: `chub`**

Check if `@aisuite/chub` is already installed globally:

```bash
chub --version 2>/dev/null && echo "installed" || echo "missing"
```

- If **missing**: install it first:
  ```bash
  pnpm install -g @aisuite/chub@latest
  ```

Then add the `get-api-docs` skill globally (whether it was already installed or just installed):

```bash
mkdir -p ~/.claude/skills/get-api-docs && curl -fsSL https://raw.githubusercontent.com/andrewyng/context-hub/main/cli/skills/get-api-docs/SKILL.md -o ~/.claude/skills/get-api-docs/SKILL.md
```

Report whether chub was already installed or freshly installed, and confirm the skill was added to `~/.claude/skills/get-api-docs/SKILL.md`.

## Step 5: Upsert external skills

**Argument: `skills`**

```bash
bash "<base-dir>/scripts/upsert-skills.sh"
```

## Step 6: Upsert rules

**Argument: `rules`**

```bash
bash "<base-dir>/scripts/upsert-rules.sh"
```

## Step 7: Upsert Claude Code settings

**Argument: `settings`**

```bash
bash "<base-dir>/scripts/upsert-claude-settings.sh"
```

## Step 8: Upsert plugins

**Argument: `plugins`**

```bash
bash "<base-dir>/scripts/upsert-plugins.sh"
```

## Completion

Report the output of each step that was run, then stop.
