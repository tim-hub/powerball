# Powerball Improvement Plugin

Skills and hooks for continuous workflow improvement — logging skill usage, distilling sessions into reusable skills, and refining existing skills.

## Skills

| Skill | Purpose |
|-------|---------|
| `distill-session` | Distill a session's repeatable workflow into a new project skill |
| `update-skill` | Refine an existing project skill with new learnings |

## Hooks

- `log-skill.sh` — logs every skill invocation for the usage report
- `suggest-compact.sh` — suggests compaction when context grows large
