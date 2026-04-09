# Powerball PBL — Plan, Build, Lodge

A spec-driven development plugin for Claude Code.

## Core Flow: PBL

```
/explore → /plan → /build → /lodge
```

| Step | Skill | What it does |
|------|-------|-------------|
| **Explore** | `/explore` | Guided codebase exploration, saves findings to `.powerball/specs/` |
| **Plan** | `/plan` | Implementation plan with architecture decisions, tasks, and checklist |
| **Build** | `/build` | Execute tasks with subagents in worktrees, verify checklist, code review |
| **Lodge** | `/lodge` | Move completed specs to `.powerball/lodge/` |

- Uses Claude Code [built-in agents](https://code.claude.com/docs/en/sub-agents) (Explore, Plan) for exploration and planning.
- Uses [SubAgent Driven Development](https://github.com/obra/superpowers/blob/main/skills/subagent-driven-development/SKILL.md) for parallel task execution in isolated worktrees.
- Mermaid diagrams are used for human and agent friendly reporting of findings, plans, and progress.

## Comparison with other agent coding tools

OpenSpec is good, but it does not use full power of Claude Code, since it is focusing on different agent coding tools.

### Credits

The `build` skill and `code-reviewer` agent are adapted from [superpowers](https://github.com/obra/superpowers) by Jesse Vincent, simplified to focus on clarity over quantity.
