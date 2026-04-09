---
name: skill-review
description: This skill should be used when the user asks to "review a skill", "check skill quality", "review my SKILL.md", "audit skills", or wants to ensure skills are clear, consistent, and follow repo conventions. Use proactively after creating or editing any skill in this repo.
argument-hint: "[path to skill directory or SKILL.md]"
user-invocable: true
model: opus
agent: plugin-dev:skill-reviewer
---

Review one or more skills for clarity, consistency, and adherence to this repo's conventions.

**Input**: A path to a skill directory or SKILL.md file. If no path is given, find all SKILL.md files under `core/`, `openspec-plugin/`, and `openspec-rewrite/` and review each.

---

## Step 1: Locate the skill(s)

If a path was provided, resolve it to one or more SKILL.md files. Otherwise:

```bash
find ./ -name "SKILL.md" | sort
```

---

## Step 2: Run the base review

For each skill, invoke the `plugin-dev:skill-reviewer` agent to run the standard quality check. This covers:
- Description trigger phrases and third-person format
- Writing style (imperative form, not second person)
- Progressive disclosure (lean body, details in references/)
- Word count and organization

---

## Step 3: Apply repo-specific consistency checks

After the base review, apply these additional checks specific to this repo:

### Frontmatter key audit

Read the frontmatter and check the following — **report issues, but never suggest removing any existing key or value**:

| Key | Expected pattern | Common issue |
|-----|-----------------|--------------|
| `name` | kebab-case, matches directory name | Wrong order or mismatch |
| `description` | Starts with "This skill should be used when..." | Second-person or vague |
| `user-invocable` | `true` for user-facing skills | Missing on public skills |
| `model` | `haiku` for lightweight tasks | Missing entirely |
| `argument-hint` | Present if skill takes an argument | Missing when skill accepts args |
| `tools` / `allowed-tools` | **Note the inconsistency**: for example, some places uses `tools` , others use `allowed-tools`. Flag which variant is used and recommend normalizing to `allowed-tools`, but do NOT remove the existing key — add a note only. |
| `disable-model-invocation` | Only when skill delegates entirely to scripts/bash | Check if value matches actual skill behavior |
| `context` | `fork` when skill needs isolated context | Consistent with similar skills |

### Writing style check

- Body uses imperative form: "Run X", "Check if Y" — not "You should run X"
- No second person ("you", "your") in the body instructions
- Steps are numbered and clearly separated
- Code blocks have language hints where appropriate (` ```bash ` not bare ` ``` `)

### Cross-skill consistency

Compare the skill against others in the same plugin directory:
- Frontmatter key order (repo convention: `name` → `description` → `user-invocable` → `model` → others)
- Step naming format (`## Step N: Title` pattern)
- Guardrails section present for skills with side effects

---

## Step 4: Output the review

For each skill, produce:

```
## Review: <skill-name> (<path>)

### Base Review (plugin-dev:skill-reviewer)
[paste or summarize the base review output]

### Repo Consistency
**Frontmatter:**
- [key]: [status — OK / issue / recommendation]

**Writing style:** [OK / issues found]

**Cross-skill consistency:** [OK / differences noted]

### Issues
**Critical:** [must fix — breaks triggering or behavior]
**Minor:** [inconsistency or style drift]

### Recommended changes
[Specific edits — never removing existing frontmatter keys]
```

---

## Guardrails

- **Never remove frontmatter keys or values** — only add missing ones or suggest value changes
- If a skill has `model: haiku` and `agent: junior`, that is intentional — do not flag it as redundant
- Flag the `tools` / `allowed-tools` / `allowed-tool` inconsistency as a **repo-wide note**, not a per-skill critical issue
- When suggesting description rewrites, preserve all semantic content — only improve format and trigger coverage
- Do not suggest splitting skills into references/ unless the body exceeds 300 lines
