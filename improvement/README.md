# Powerball Improvement Plugin

Skills and hooks for continuous workflow improvement — logging skill usage, distilling sessions into reusable skills, refining existing skills, distilling cognitive frameworks from people, and autonomously optimizing skills.

## Skills

| Skill | Purpose |
|-------|---------|
| `distill-session` | Distill a session's repeatable workflow into a new project skill |
| `update-skill` | Refine an existing project skill with new learnings |
| `huashu-nuwa` | Distill how a person/topic thinks into a runnable `*-perspective` skill |
| `darwin-skill` | Autonomously evaluate and improve an existing skill against a rubric |

## Hooks

- `log-skill.sh` — logs every skill invocation for the usage report
- `suggest-compact.sh` — suggests compaction when context grows large

## Attribution

`huashu-nuwa` and `darwin-skill` are vendored from third-party open-source skills by **花叔 (Huashu / [@AlchainHust](https://x.com/AlchainHust))**, both MIT-licensed:

| Skill | Source | License |
|-------|--------|---------|
| `huashu-nuwa` | https://github.com/alchaincyf/nuwa-skill | MIT (see `skills/huashu-nuwa/LICENSE`) |
| `darwin-skill` | https://github.com/alchaincyf/darwin-skill | MIT |

Only the functional core of each was vendored (`SKILL.md`, `references/`, `scripts/`, darwin's `templates/`). Examples, promo material, assets, and multi-language READMEs were omitted. Self-references were adapted to `$CLAUDE_PLUGIN_ROOT`, and an English-output directive was added at the top of each skill.
