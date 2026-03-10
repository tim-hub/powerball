# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

**Powerball** is a Claude Code plugin — a curated collection of commands, skills, agents, and hooks that extend Claude Code for git workflows, issue resolution, code review, creative writing, and documentation/code-example lookup.

Installed via: `/plugin marketplace add tim-hub/powerball`, then `/powerball:get-started`.

## Plugin Architecture

The plugin manifest lives in `.claude-plugin/plugin.json`. Components auto-discovered by Claude Code:

| Component | Location | Loaded When | Context Cost |
|-----------|----------|-------------|--------------|
| Commands  | `commands/*.md` | When invoked (`/powerball:<name>`) | On use |
| Skills    | `skills/<name>/SKILL.md` | Descriptions at session start; full content on use | Low |
| Agents    | `agents/*.md` | When spawned as subagent | Isolated context |
| Hooks     | `.claude-plugin/hooks/hooks.json` | On trigger event | Zero |
| MCP Servers | `.mcp.json` | Session start | Every request |

## Component Relationships

Commands are thin dispatchers that delegate to skills or agents:
- `/commit` → `smart-committer` agent
- `/pr` → `pr-writing` skill
- `/solve <issue|description>` → `fix-issue` or `fix-problem` skill (based on input type)
- `/review` → `superpowers:requesting-code-review` skill (external plugin)
- `/tag`, `/archive` → self-contained Bash logic

Skills compose agents: `fix-issue` uses `smart-committer` agent + `pr-writing` skill as sub-steps.

## Model Selection Pattern

Choose models based on task complexity — this directly affects cost and speed:
- **haiku**: Commit, tag, PR creation, doc lookup, code search (simple, deterministic tasks)
- **sonnet**: Issue fixing and problem solving (requires reasoning)
- **opus**: Code review (requires deep judgment)

## MCP Integrations

Two MCP HTTP servers defined in `.mcp.json`:
- **context7** (`mcp.context7.com`) — versioned library documentation; used exclusively by the `doc_checker` agent
- **gh_grep** (`mcp.grep.app`) — GitHub code search across public repos; used exclusively by the `gh_greper` agent

Always use these agents rather than relying on training data for library APIs or code patterns.

## Adding New Components

**New command**: Create `commands/<name>.md` with YAML frontmatter (`name`, `description`, `model`, optional `argument-hint`, `tools`).

**New skill**: Create `skills/<name>/SKILL.md` with YAML frontmatter. The `description` field is critical — it determines when the skill auto-triggers.

**New agent**: Create `agents/<name>.md` with frontmatter including `model`, `color`, and tool `allow`/`deny` lists to scope what the agent can access.

## Key Conventions

- Think before act.
- Follow existing pattern, style and structure in the codebase.
- Always use `powerball:doc_checker` subagent when need library/API documentation, code generation, setup or configuration steps.
- Always use `powerball:gh_greper` subagent when need real-world code examples, or usage of specific libraries.
- Use `disable-model-invocation: true` in command frontmatter when the command purely dispatches to a skill (no model call needed at the command level).
- Agents should have narrow tool allowlists — only grant what's needed (e.g., `doc_checker` only gets context7 MCP tools).
- The Stop hook in `.claude-plugin/hooks/hooks.json` alerts on mixed staged/unstaged changes — it runs a bash one-liner with zero context cost.
