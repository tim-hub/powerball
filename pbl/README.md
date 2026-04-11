# Powerball PBL — Plan, Build, Lodge

A spec-driven development plugin for Claude Code. 🤞

Claude Code's built-in agents are really good. PBL leans into them — using native skills and agents as much as possible, adding just enough structure to make spec-driven development reliable.

## Core Flow

```
/plan → /build → /lodge
```

| Step | Skill | What it does |
|------|-------|-------------|
| **Plan** | `/plan` | Implementation plan with architecture decisions, tasks, and checklist |
| **Build** | `/build` | Execute tasks with subagents in worktrees, verify checklist, code review |
| **Lodge** | `/lodge` | Move completed specs to `.powerball/lodge/` |

Optional: `/explore` for guided codebase exploration before planning. Saves findings to `.powerball/specs/`.

- Delegates to Claude Code's [built-in Explore ~~and Plan~~ agents](https://code.claude.com/docs/en/sub-agents) — no reimplementing what already works well. ✅
- Parallel task execution in isolated git worktrees, following [SubAgent Driven Development](https://github.com/obra/superpowers/blob/main/skills/subagent-driven-development/SKILL.md).
- Mermaid diagrams for human and agent friendly reporting throughout.

## Why not OpenSpec?

This is heavily inspired by OpenSpec. But it's designed for multiple agent tools — so it doesn't use the full power of Claude Code. PBL does. 😊

### Credits

The `build` skill and `code-reviewer` agent are adapted from [superpowers](https://github.com/tim-hub/superpowers) simplified to focus on clarity over quantity.
