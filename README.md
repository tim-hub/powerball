## Powerball

A marketplace of Claude Code plugins for productivity, git workflows, and workplace integrations.

### Plugins

#### `powerball-core`
Agents and skills for everyday Claude Code usage:
- Small, fast agents for specific tasks — smart commits, code tagging, doc searching, and code example searching
- `/get-started` — install well-rated plugins from the official marketplace and superpowers, with interactive setup and configuration including statusline
- A hook to warn when you have both staged and unstaged changes

#### `powerball-workplace`
Skills for workplace tool integrations:
- Jira ticket analyzer — fetch and analyze Jira tickets to produce actionable development plans

### Install

```
/plugin marketplace add tim-hub/powerball
```

Then run `/get-started` to set up statusline and install recommended plugins.

> You may need to temporarily disable sandbox mode for the session, because this skill edits `~/.claude` to add the statusline script. You can re-enable it after setup.

#### Manual installation

Clone the repository to your local machine.

### Others

- [Why create this plugin?](docs/why%20create%20this%20plugin.md)
- [FAQ](docs/FAQ.md)