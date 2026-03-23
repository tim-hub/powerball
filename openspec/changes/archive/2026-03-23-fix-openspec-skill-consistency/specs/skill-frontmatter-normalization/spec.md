## ADDED Requirements

### Requirement: Frontmatter key order matches repo convention
Each of the 8 generated SKILL.md files SHALL have frontmatter keys in the order: `name` → `description` → `argument-hint` → `user-invocable` → `model` → `allowed-tools` → `agent` → `context` → `disable-model-invocation` → `license` → `compatibility` → `metadata`. Keys not present in a given skill are skipped.

#### Scenario: Reorder openspec-apply-change frontmatter
- **WHEN** `openspec-rewrite/skills/openspec-apply-change/SKILL.md` frontmatter is checked
- **THEN** keys appear in the standard order with `name` first, `description` second, non-standard keys (`license`, `compatibility`, `metadata`) last

#### Scenario: All 8 skills follow same order
- **WHEN** all 8 generated SKILL.md files are compared
- **THEN** every file uses the same key ordering convention

### Requirement: All change-management skills declare argument-hint
Each of the 8 change-management skills SHALL include `argument-hint: "[change name]"` in the frontmatter, since all accept an optional change name argument.

#### Scenario: argument-hint present on openspec-apply-change
- **WHEN** `openspec-apply-change/SKILL.md` frontmatter is read
- **THEN** it contains `argument-hint: "[change name]"`

#### Scenario: argument-hint present on all 8 skills
- **WHEN** all 8 generated SKILL.md frontmatter blocks are checked
- **THEN** each contains `argument-hint: "[change name]"`

### Requirement: Lightweight skills specify model haiku
Skills that perform only scaffolding or mechanical operations SHALL include `model: haiku`. Specifically: `openspec-new-change` and `openspec-sync-specs`.

#### Scenario: openspec-new-change has model haiku
- **WHEN** `openspec-new-change/SKILL.md` frontmatter is read
- **THEN** it contains `model: haiku`

#### Scenario: openspec-sync-specs has model haiku
- **WHEN** `openspec-sync-specs/SKILL.md` frontmatter is read
- **THEN** it contains `model: haiku`
