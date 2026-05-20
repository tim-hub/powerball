---
name: multica
description: "Runs Multica CLI commands by mapping the user's request to the right `multica <command>` invocation. Use when the user asks to do anything with Multica — issues, agents, workspaces, autopilots, skills, squads, or the daemon."
when_to_use: "multica, multica cli, multica login, multica issue, multica agent, multica autopilot, multica daemon, multica workspace, multica squad, multica skill, multica runtime, multica repo, multica setup, multica config"
allowed-tools: Bash
---

# Multica CLI

## Overview

Thin pass-through skill: translate the user's request into a `multica <command> [args]` call and run it. Reference: https://multica.ai/docs/cli

## Quick Reference

| Area | Common commands |
|------|-----------------|
| Auth/setup | `multica login`, `multica auth status`, `multica auth logout`, `multica setup cloud`, `multica setup self-host` |
| Workspaces | `multica workspace list`, `multica workspace get <slug>`, `multica workspace member list`, `multica workspace update <id>` |
| Issues | `multica issue list`, `multica issue get <id>`, `multica issue create`, `multica issue assign <id> --agent <slug>`, `multica issue search <query>` |
| Projects | `multica project list|get|create` |
| Agents | `multica agent list`, `multica agent get <slug>`, `multica agent create`, `multica agent tasks <slug>` |
| Skills | `multica skill list|get|create`, `multica skill import <url-or-path>` |
| Squads | `multica squad list`, `multica squad create --name <n> --leader <slug>`, `multica squad member add <id> --agent <slug>` |
| Autopilots | `multica autopilot list`, `multica autopilot create --name <n>`, `multica autopilot trigger <id>` |
| Daemon/runtime | `multica daemon start`, `multica daemon status`, `multica runtime list`, `multica runtime usage` |
| Misc | `multica repo checkout <url>`, `multica config`, `multica version`, `multica update` |

## How to Use

1. Identify the area + verb from the user's request (e.g. "assign issue MUL-12 to the reviewer bot" → `multica issue assign MUL-12 --agent reviewer`).
2. Pick the matching command from the table above.
3. For flags you're unsure about, run `multica <command> --help` first — never guess flag names.
4. Run via Bash and return the CLI output to the user.

## Preflight Checks

- If a command errors with auth/login issues, suggest `multica login` then retry.
- If `multica` is not found, ask the user to install it (don't try to install it automatically).
- Don't invent commands not in the table; if the user asks for something not listed, run `multica --help` or `multica <area> --help` and adapt from real output.

## Example

User: "create an autopilot named Daily Review and trigger it"
```bash
multica autopilot create --name "Daily Review"
# capture the returned ID, e.g. ap-123
multica autopilot trigger ap-123
```

## Notes

- IDs/slugs are arguments, not flags (e.g. `multica issue get MUL-123`, not `--id MUL-123`).
- For full flag coverage on any command: `multica <command> --help`.
