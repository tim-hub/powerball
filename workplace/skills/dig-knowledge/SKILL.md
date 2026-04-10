---
name: dig-knowledge
description: "Search the development knowledge base for past work, decisions, and lessons learned on a project. Use this skill when the user asks 'how did we fix X', 'what did we do last time', 'any past notes on this', 'check knowledge base', 'dig knowledge', 'what do we know about this project', or asks questions about past development context. Also trigger during explore and plan workflows to silently load relevant project history. If no knowledge base is configured or the project has no entries, skip silently — never block the user's workflow."
user-invocable: true
argument-hint: "[project name or search term — e.g. 'my-app', 'auth issues', or leave blank for current project]"
---

# Dig Knowledge

Search the knowledge base for past development context — what was done, why, and what challenges were faced — to inform current work.

This skill is the read side of the knowledge system. It pulls in relevant history so you don't repeat mistakes or re-discover solutions that were already found.

## Silent Skip Rule

If any script in Step 1 exits non-zero, **skip silently** — do not warn, prompt, or mention the knowledge base. This skill should never be a friction point. If there's nothing to read, move on.

## Step 1: Load Config and Resolve Project

Run the load script:

```bash
python3 "${CLAUDE_PLUGIN_ROOT}/skills/dig-knowledge/scripts/kb-load.py" "[optional_project_name]"
```

- Pass the user's argument as the project name if it looks like a project name (single word, no spaces).
- If no argument or the argument is a search query, omit it — the script derives the project from the cwd.
- If the script exits **non-zero** → silent skip. Config missing, path not set, or folder doesn't exist.
- If it exits **0**, it prints JSON: `{ "kb_path": "...", "project": "...", "project_path": "...", "has_entries": true/false }`
- If `has_entries` is `false` → silent skip.

## Step 2: Search Knowledge

Run the search script:

```bash
python3 "${CLAUDE_PLUGIN_ROOT}/skills/dig-knowledge/scripts/kb-search.py" "{project_path}" "[search_term]"
```

- If the user provided a search term (e.g., "auth issues", "CSV export bug"), pass it as the second argument. The script matches filenames first, then greps content.
- If no search term, omit it — the script returns the 5 most recent entries.
- The script outputs one file path per line. Read the returned files.

## Step 3: Present Findings

**When invoked explicitly by the user** — show a structured summary:
- List matching entries with dates and titles
- Show the key bullet points from each relevant entry
- Highlight anything that might be relevant to the current task

**When invoked silently during explore/plan** — inject context naturally:
- Don't announce "I found knowledge base entries"
- Instead, weave relevant history into your exploration or planning output
- Reference past decisions where they inform current choices (e.g., "Previously, X approach was chosen because Y — this is still relevant here")

## Integration with Explore and Plan

When the `explore` or `plan` skills run, this skill can be invoked as a preliminary step to load project history. The calling skill should:

1. Call `dig-knowledge` with the current project name
2. If results come back, include them as context for the exploration/plan
3. If silent skip, proceed normally

This integration is optional — explore and plan work fine without it. Knowledge just makes them better informed.
