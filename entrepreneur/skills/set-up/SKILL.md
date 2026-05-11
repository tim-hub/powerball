---
name: set-up
description: Use when the user asks to "set up entrepreneur tools", "install marketing plugins", "bootstrap my Claude for startup work", or "entrepreneur setup". Installs PM, marketing, growth, and inference-sh plugins.
model: haiku
allowed-tools: Bash, Read
user-invocable: true
---

The base directory for this skill is shown in the header when invoked. All script paths use `<base-dir>/scripts/`.

## What this installs

- **inference-sh** — AI inference and automation skills from `inference-sh/skills`
- **PostHog** — Product analytics plugin (`posthog`)
- **PM toolkit** — Product management, strategy, discovery, market research, analytics, marketing growth, go-to-market, and execution skills from `phuryn/pm-skills`

## Step 1: Install plugins

Run the upsert script:

```bash
bash "<base-dir>/scripts/upsert-plugins.sh"
```

## Completion

Report what was installed and remind the user to restart Claude Code for plugins to take effect.
