---
name: kb
description: Knowledge base maintenance skill. Use this skill to save, update, or upsert insights, learnings, decisions, and important information gained during a conversation to the project's knowledge base. Trigger this skill whenever the user gains a new insight, makes an important decision, wants to remember something, or says "save this to kb", "add to knowledge base", "remember this", "note this down", "kb add", "kb upsert", "kb update". Also trigger proactively after solving a complex problem, completing a feature, or discovering a non-obvious pattern.
argument-hint: "[add|upsert|update] [optional: topic or content description]"
user-invocable: true
allowed-tools: Bash, Read
context: fork
model: haiku
---

Maintain the project knowledge base by upserting insights and information into a structured markdown file.

## Setup Check

Before any operation, verify the KB is configured:
```bash
cat ~/.kb/config.json 2>/dev/null
```
If the config is missing or empty, invoke the `kb-setup` skill first.

## Determine Operation

Parse the argument:
- `add`, `upsert`, or `update` (or no subcommand) → **upsert** (default)
- The rest of the argument is the topic hint or content description

## Get Project Context

1. Get the project name from the current working directory folder name:
   ```bash
   basename "$PWD"
   ```
2. Read `allow_list[0]` from `~/.kb/config.json` — this is the base KB directory.
3. The KB file path is: `<allow_list[0]>/kb/<project-name>.md`

## Upsert Process

Run `scripts/upsert.sh` with the required arguments:
```bash
bash <skill-dir>/scripts/upsert.sh "<kb-file-path>" "<topic>" "<content>"
```

Where:
- `<kb-file-path>` — full path to the project's KB markdown file
- `<topic>` — the section heading (derived from the conversation context or argument hint)
- `<content>` — the actual insight or information to save

The script handles file creation from template, section detection via ripgrep, and appending or updating content.

## What to Save

When triggered proactively (not by explicit user command), distill the conversation into:
- **Topic**: a short, specific heading (e.g., "JWT token refresh strategy", "Database migration approach")
- **Content**: 2-5 concise bullet points capturing the key insight, decision rationale, or pattern discovered

Avoid saving trivial or obvious information. Focus on non-obvious insights, gotchas, decisions with meaningful trade-offs, or patterns specific to this project.

## Output

After the upsert, confirm briefly:
- What topic was saved
- The file path it was written to
- Whether it was a new section or an update to an existing one

## References

- Template: `templates/kb.template.md` — used when creating a new KB file
- Script: `scripts/upsert.sh` — handles all file I/O and ripgrep-based section detection
