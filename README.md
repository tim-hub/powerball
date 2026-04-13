## Powerball

A marketplace of Claude Code plugins for productivity, git workflows, spec-driven development, and workplace integrations.

If you are looking for PowerBall Harness, it is located at [tim-hub/powerball-harness](https://github.com/tim-hub/powerball-harness).

> In theory all the skills and scripts can be worked on other agent coding tools too, however, this was not tested.

### Plugins


#### `powerball-pbl`
Plan, Build, Lodge — spec-driven development pipeline:
- `/explore` — guided codebase exploration with Mermaid diagrams, saved to `.powerball/specs/`
- `/plan` — implementation planning with architecture decisions, tasks, and checklists
- `/build` — task execution with subagents in worktrees, checklist verification, and code review
- `/lodge` — move completed specs to `.powerball/lodge/`
- [more](pbl/README.md)

#### `powerball-workplace`
Skills for workplace tool integrations:
- Jira ticket analyzer — fetch and analyze Jira tickets to produce actionable development plans
- Build knowledge — capture what was done, why, and challenges faced to a persistent knowledge base
- Dig knowledge — search past development knowledge during exploration, planning, or troubleshooting

### Install

```
/plugin marketplace add tim-hub/powerball
```

Install 4 plugins,
- personal (compulsory, the other plugins depend on this one)
- pbl - [more](pbl/README.md)
- workplace - [more](workplace/README.md)
- openspec-rewrite - [more](openspec-rewrite/README.md)



Then run `/get-started` to set up statusline and install recommended plugins.

> You may need to temporarily disable sandbox mode for the session, because this skill edits `~/.claude` to add the statusline script. You can re-enable it after setup.


If you want to set up a skill set of openspec globally, run `setup-openspec`


#### Manual installation

Clone the repository to your local machine.

### Others

- [Why create this plugin?](docs/why%20create%20this%20plugin.md)
- [FAQ](docs/FAQ.md)



- Claude Code Focus
- Do not remove frontmatter key values
- Focus on keeping skills clear and straightforward


VibeGuard is recommended.

- `curl -fsSL https://raw.githubusercontent.com/inkdust2021/VibeGuard/refs/heads/main/install.sh | bash`
- use `vibeguard claude` instead of `claude`