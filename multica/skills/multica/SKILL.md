---
name: multica
description: "Runs Multica CLI commands by mapping the user's request to the right `multica <command>` invocation. Use when the user asks to do anything with Multica — issues, agents, workspaces, autopilots, skills, squads, or the daemon."
when_to_use: "multica, multica cli, multica login, multica issue, multica agent, multica autopilot, multica daemon, multica workspace, multica squad, multica skill, multica runtime, multica repo, multica setup, multica config, batch update agents, create squad, assign skill, label create, autopilot create"
allowed-tools: Bash
---

# Multica CLI

## Overview

Thin pass-through skill: translate the user's request into a `multica <command> [args]` call and run it. Reference: https://multica.ai/docs/cli

## Quick Reference

| Area | Common commands |
|------|-----------------|
| Auth/setup | `multica login`, `multica auth status`, `multica setup cloud` |
| Workspaces | `multica workspace list`, `multica workspace get <slug>`, `multica workspace update <id>` |
| Issues | `multica issue list`, `multica issue get <id>`, `multica issue create`, `multica issue update <id>`, `multica issue search <query>` |
| Labels | `multica label create --name <n> --color "#hex"`, `multica label list` |
| Projects | `multica project list\|get\|create` |
| Agents | `multica agent list`, `multica agent get <slug>`, `multica agent create`, `multica agent update <id>`, `multica agent tasks <slug>` |
| Skills | `multica skill list\|get\|create`, `multica skill import <url-or-path>` |
| Squads | `multica squad list`, `multica squad create --name <n> --leader <id>`, `multica squad member add <id> --member-id <agent-id> --type agent` |
| Autopilots | `multica autopilot list`, `multica autopilot create`, `multica autopilot update <id>`, `multica autopilot trigger-add <id>` |
| Daemon/runtime | `multica daemon start`, `multica daemon status`, `multica runtime list` |

## How to Use

1. Identify the area + verb from the user's request.
2. Pick the matching command from the table above.
3. For unknown flags, run `multica <command> --help` first — never guess flag names.
4. Run via Bash and return the output.

## Batch Updates via Python

For multi-entity changes (create N agents, bulk-update instructions, assign skills), use a Python subprocess wrapper and loop:

```python
import json, subprocess

def multica(*args):
    r = subprocess.run(["multica"] + list(args), capture_output=True, text=True)
    return r.stdout.strip(), r.returncode

agents = json.loads(multica("agent", "list", "--output", "json")[0])
for a in agents:
    multica("agent", "update", a["id"], "--instructions", new_body, "--output", "table")
```

Always pass UUIDs, not names — fuzzy name match errors on ambiguous suffixes (e.g. "planner" can match planner, planner-qwen, gan-planner, etc.).

## Autopilots — Full Lifecycle

`create` and `trigger-add` are separate steps:

```bash
# 1. Create
multica autopilot create \
  --title "stage-name" \
  --agent <uuid> \
  --mode run_only \
  --description "<prompt>" \
  --output json

# 2. Add schedule trigger
multica autopilot trigger-add <autopilot-id> \
  --kind schedule --cron "*/5 * * * *" --label "my-poll"
```

- `--mode run_only` — acts on existing issues (label-scanning flows)
- `--mode create_issue` — periodic issue creation (needs `--issue-title-template`)
- `multica autopilot get <id> --output json` returns `{"autopilot": {...}, "triggers": [...]}` — note the nesting, not a flat object

For label-driven multi-stage flows, chain stages via label flips only — the next autopilot's scheduled scan picks the issue up automatically. No agent assignment calls needed between stages.

## Gotchas

- **`label create` needs `--color`**: `multica label create --name X --color "#3b82f6"`. Omitting it fails the command.
- **Close an issue**: `multica issue update <id> --status closed`. There is no `multica issue status` command.
- **Reassign an issue**: `multica issue update <id> --assignee-id <uuid>`. Not `--to` or `--assign`.
- **Ambiguous agent names**: many commands accept `--agent <name>` but error when clones exist with similar names. In scripts, resolve to UUID first via `agent list --output json`.
- **Extract IDs from text output**: create commands emit `Created: <uuid>` or `... (<uuid>)` in table output — use regex `r'([a-f0-9-]{36})'` when `--output json` isn't available.
- **`--output json` parsing**: most list commands return a JSON array; `autopilot get` and a few others wrap in an object. Always inspect the raw output on first use.

## Preflight Checks

- Auth errors → suggest `multica login` then retry.
- `multica` not found → ask the user to install it.
- Don't invent commands; run `multica <area> --help` and adapt from real output.
