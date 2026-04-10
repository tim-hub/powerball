---
name: build-knowledge
description: "Capture and save development knowledge — what was done, why, challenges faced, and key decisions — to a persistent knowledge base folder. Use this skill after completing a feature, fixing a bug, finishing a plan, resolving a tricky issue, or when the user says 'save what we did', 'document this work', 'build knowledge', 'capture learnings', 'save development notes', 'log this work', or wants to record development context for future reference. Also trigger when wrapping up a significant piece of work that involved non-obvious decisions or debugging. This skill MUST run as a subagent (never in main context) to avoid polluting the conversation."
user-invocable: true
argument-hint: "[optional: brief description of work to capture, or leave blank to auto-summarize]"
---

# Build Knowledge

Summarize development work — what was done, why decisions were made, and what challenges were encountered — then save it as a structured markdown file in a user-configured knowledge base folder.

This skill exists because code tells you *what* was built, but not *why* it was built that way, what alternatives were considered, or what tripped you up. Over time, this knowledge base becomes a searchable record of lessons learned across all your projects.

## Important: Subagent Only

This skill should NEVER run in the main conversation context. Always dispatch it as a subagent so the summarization work doesn't clutter the user's session. The calling agent should pass relevant context (recent changes, conversation summary, project name) when spawning.

## Step 1: Initialize and Load Config

Run the init script to ensure the config file exists and the knowledge base path is set:

```bash
python3 "${CLAUDE_PLUGIN_ROOT}/skills/build-knowledge/scripts/kb-init.py"
```

- If it exits with code **0**, it prints the `knowledge_base_path` to stdout. Capture it.
- If it exits with code **1**, the config exists but `knowledge_base_path` is not set yet. Ask the user which folder to use, then run again with the path as an argument:
  ```bash
  python3 "${CLAUDE_PLUGIN_ROOT}/skills/build-knowledge/scripts/kb-init.py" "/path/user/chose"
  ```
  This writes the path to config and creates the directory.

Then run the load script to resolve the project:

```bash
python3 "${CLAUDE_PLUGIN_ROOT}/skills/build-knowledge/scripts/kb-load.py"
```

This outputs JSON: `{ "kb_path": "...", "project": "...", "project_path": "..." }`. Create the `project_path` directory if it doesn't exist.

## Step 2: Gather Context

Collect information about what was done. Sources to check:

1. **Git diff / recent commits** — `git log --oneline -10` and `git diff --stat` to see what changed
2. **Conversation context** — the argument passed to this skill, or the parent agent's summary of the session
3. **Spec files** — check `.powerball/specs/` for any active plans or explorations that describe the work
4. **Jira ticket** — if a Jira ticket number appears in branch names, commit messages, or conversation context, note it

## Step 3: Write the Knowledge Entry

Create a file at:

```
{project_path}/YYYY-MM-DD--{slug}.md
```

Where `{slug}` is a short, kebab-case name describing the work (e.g., `auth-token-refresh-fix`, `add-csv-export`, `migrate-to-postgres`). Keep it under 6 words.

If a file with the same date and slug already exists, append a numeric suffix: `YYYY-MM-DD--{slug}-2.md`.

### File Format

```markdown
# {Title — human-readable version of the slug}

**Date:** YYYY-MM-DD
**Project:** {project-name}
{if Jira ticket: **Jira:** [TICKET-123](https://your-jira-instance.atlassian.net/browse/TICKET-123)}

## What was done
- {2-4 bullet points summarizing the changes}

## Why it was done this way
- {Key decisions and reasoning — alternatives considered, trade-offs made}

## Challenges & lessons
- {What was tricky, what broke, what you learned}

## Key files touched
- {List of the most important files changed, not every file}
```

Keep it concise — aim for a file someone can scan in 30 seconds and get the full picture. This isn't a changelog; it's the story behind the change.

## Step 4: Confirm

Tell the user (or parent agent) where the file was saved and show a brief preview of the content.
