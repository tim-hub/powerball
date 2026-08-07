## Powerball

A marketplace of Claude Code plugins for translation and workflow improvement.

- If you are looking for PowerBall Harness, it is located at [tim-hub/powerball-harness](https://github.com/tim-hub/powerball-harness).
- I also maintained a [clone of superpowers](https://github.com/tim-hub/superpowers) for Claude Code only, it give up compatibility to other agents to gain better practices and native features from ClaudeCode.

> In theory all the skills and scripts can be worked on other agent coding tools too, however, this was not tested.

### Plugins

#### `writing`
Translation skills — `language-translate` for text and `translate-markdown` for markdown files.

#### `improvement`
Hooks only — logs every skill invocation to `~/.claude/skill-usage.log` and suggests compaction when context grows large.

### Install

```
/plugin marketplace add tim-hub/powerball
```

Then install `writing`, `improvement`, or both.

#### Install skills without a plugin

The writing skills can also be installed individually via [skills](https://github.com/vercel-labs/skills), without adding the marketplace:

```bash
bunx skills add https://github.com/tim-hub/powerball/tree/master/writing/skills
```

Add `--skill <name>` to install a single skill from that folder, or `-g` to install globally.

#### Manual installation

Clone the repository to your local machine.

### Others

- [Why create this plugin?](docs/why%20create%20this%20plugin.md)
- [FAQ](docs/faq.md)



- Claude Code Focus
- Do not remove frontmatter key values
- Focus on keeping skills clear and straightforward


VibeGuard is recommended.

- `curl -fsSL https://raw.githubusercontent.com/inkdust2021/VibeGuard/refs/heads/main/install.sh | bash`
- use `vibeguard claude` instead of `claude`
