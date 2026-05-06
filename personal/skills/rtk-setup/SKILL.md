---
name: rtk-setup
description: Use this skill when the user wants to install or configure rtk (Rust Token Killer), a token-optimized CLI proxy for Claude Code. Triggered by "install rtk", "set up rtk", "configure rtk", or as part of the get-started flow.
model: haiku
allowed-tools: Bash, Read, Write, Edit
disable-model-invocation: true
user-invocable: true
---

# RTK Setup

RTK (Rust Token Killer) is a CLI proxy that reduces token usage 60-90% on dev operations by filtering and compressing command output before it reaches Claude.

## Step 1: Install rtk

Check if `rtk` is already installed:

```bash
rtk --version 2>/dev/null && echo "installed" || echo "missing"
```

- If **installed**: skip installation and proceed to Step 2.
- If **missing**: install via Homebrew:
  ```bash
  brew install rtk
  ```

## Step 2: Initialize rtk globally

Run rtk init in global mode with auto-patching enabled:

```bash
rtk init -g --auto-patch
```

This patches the global Claude Code hook configuration so all shell commands are transparently proxied through rtk.

## Step 3: Disable telemetry

```bash
rtk telemetry disable
```

## Step 4: Verify installation

Run a quick verification to confirm everything is working:

```bash
rtk --version
rtk gain
```

Expected output from `rtk gain`: token savings analytics dashboard. If you see "command not found", check for a name collision with `reachingforthejack/rtk` (Rust Type Kit) — run `which rtk` to confirm the correct binary is on PATH.

## Completion

Report:
- Whether rtk was already installed or freshly installed
- Confirmation that `rtk init -g --auto-patch` completed
- Confirmation that telemetry was disabled
- Output of `rtk gain` to show it's working
