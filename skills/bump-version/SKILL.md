---
description: Bump the version of Claude Code plugin by updating the version field in .claude-plugin/plugin.json and .claude-plugin/marketplace.json, and tagging the new version in git. Triggered by requests like "bump version", "update version", or "release new version" in a Claude Code plugin project.
model: haiku
allowed-tool: Bash, Read
---

- Read .claude-plugin/plugin.json to know what is the current version.
- Increase the version update on .claude-plugin/plugin.json and .claude-plugin/marketplace.json.
- `superball:commit` command to commit it then `superball:tag` command to tag it with the same version in git too.