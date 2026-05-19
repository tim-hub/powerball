---
name: bump-plugin-version
description: "Bumps version, commits, and tags a Claude Code plugin. Use when releasing a new plugin version."
when_to_use: "bump plugin version, update plugin version, release new version, increment version, tag a new release"
disable-model-invocation: true
user-invocable: true
model: haiku
allowed-tools: Bash, Read
argument-hint: "[plugin name]"
context: fork
agent: powerball-personal:junior
---

Bump version, commit, tag. If an argument is given, target only that plugin; otherwise bump every plugin in `marketplace.json`.

## Steps

1. **Locate the manifest.** Prefer `.claude-plugin/marketplace.json`. If missing, fall back to the target plugin's own `.claude-plugin/plugin.json` and skip to step 3.
2. **Bump.** For each target plugin entry in `marketplace.json`:
   - `strict: false` → bump only in `marketplace.json`.
   - `strict: true` (or unset) → bump the plugin's `plugin.json`, then mirror the new version into `marketplace.json`.
3. **Commit and tag.** Run `powerball-personal:commit`, then `powerball-personal:tag` with the new version.
