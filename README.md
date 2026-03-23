## Powerball

A marketplace of Claude Code plugins for productivity, git workflows, and workplace integrations.

> In theory all the skills and scripts can be worked on other agent coding tools too, however, this was note tested.

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

Install 3 plugins, 
- core (compulsory, the other two dependets on this one) 
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


#### Checklist

- [ ] Add MIT License
- [ ] Add a new skill to review skills
  - Claude Code Focus
  - Do not remove frontmatter key values
  - Focus on keep skill clear, straighforward