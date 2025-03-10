---
description: Bump the version of this plugin by updating the version field in .claude-plugin/plugin.json and .claude-plugin/marketplace.json, and tagging the new version in git. Triggered by requests like "bump version", "update version", or "release new version".
model: haiku
tools:
  deny:
    - WebFetch
---

- Read .claude-plugin/plugin.json to know what is the current version.
- Increase the version update on .claude-plugin/plugin.json and .claude-plugin/marketplace.json.
- `superball:commit` to commit it then `superbal:tag` tag it with the same version in git too.