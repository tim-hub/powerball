---
name: bump-plugin-version
description: This skill should be used when the user asks to "bump plugin version", "update plugin version", "release new version", "increment version", or "tag a new release" in a Claude Code plugin project.
disable-model-invocation: true
user-invocable: true
model: haiku
allowed-tools: Bash, Read
argument-hint: "[plugin name]"
context: fork
agent: powerball-personal:junior
---

## Argument: plugin name (optional)

Use the provided argument as the name of the specific plugin to bump. Only process that plugin's entry in `marketplace.json` (and its `plugin.json` if `strict` applies). If no argument is given, process all plugins in `marketplace.json`.

## Step 1: Check for marketplace.json

Check if `.claude-plugin/marketplace.json` exists.

- If it **does not exist**: fall back to the single-plugin flow — read `.claude-plugin/plugin.json` for the target plugin, bump its version, then skip to Step 3.

## Step 2: Determine bump scope per plugin

For the target plugin entry in `marketplace.json`, check whether `strict` is `false`:

- If `strict` is **false**: the plugin version in `marketplace.json` is decoupled from the plugin's own `plugin.json`. Bump the version only in `marketplace.json`.

- If `strict` is **true** (or not set): versions must stay in sync. Go to the plugin's folder, find its `plugin.json`, bump the version there, then update `marketplace.json` to match.

## Step 3: Commit and tag

- Run the `powerball-personal:commit` skill to commit the changes.
- Run the `powerball-personal:tag` skill to tag git with the same version that was bumped.
