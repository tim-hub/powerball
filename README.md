## Powerball

A marketplace of Claude Code plugins for productivity, software development workflows, and spec-driven development.

- If you are looking for PowerBall Harness, it is located at [tim-hub/powerball-harness](https://github.com/tim-hub/powerball-harness).
- I also maintained a [clone of superpowers](https://github.com/tim-hub/superpowers) for Claude Code only, it give up compatibility to other agents to gain better practices and native features from ClaudeCode.

> In theory all the skills and scripts can be worked on other agent coding tools too, however, this was not tested.

### Plugins

#### `powerball-personal`
Agentic tools for git workflows, issue resolution, code review, creative writing, doc searching, and content translation.

#### `openspec-rewrite`
Spec-driven development — setup, explore, propose, implement, verify, sync, and archive changes.

#### `improvement`
Skill usage logging and workflow distillation — logs every skill invocation, surfaces a usage summary on session start, and provides skills for capturing and refining reusable workflows.

#### `experiment`
Sandbox for trying new hooks and skills before promoting them to a stable plugin. Requires `/optimize-skill` from the marketplace.

#### `entrepreneur`
Marketing, growth, and PM tools for founders and small teams.

### Install

```
/plugin marketplace add tim-hub/powerball
```

Install plugins:
- personal (compulsory)
- openspec-rewrite - [more](openspec-rewrite/README.md)
- improvement
- experiment
- entrepreneur



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
