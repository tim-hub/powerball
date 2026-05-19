---
name: tag
description: "Tags the current git repository with a new version tag. Use when marking a release point in git history."
when_to_use: "tag a release, create a git tag, tag this version, add a version tag, mark release"
argument-hint: "[optional tag name, e.g. v1.2.3]"
model: haiku
user-invocable: true
context: fork
agent: powerball-personal:junior
---

Tag the current git repository with a new version tag.

- [ ]  If an argument was provided, use it as the tag name exactly. Otherwise, run `git tag --sort=-version:refname | head -5` to inspect existing tags and determine the tagging pattern.
   - If the repo uses `vX.Y.Z` semver, increment the patch version (Z+1) and use that.
   - If no existing tags match a known pattern, default to the current date: `YY.MM.DD`.
- [ ] Run `git tag <new-tag>` to create the tag.
- [ ] Confirm the tag was created by running `git tag --sort=-version:refname | head -3`.
- [ ] Report the new tag name to the user.


## Guardrails

Do not push the tag unless the user explicitly asks.
