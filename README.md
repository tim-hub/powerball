## Superball
A simple collection of agents and skills and commands to use Claude Code effectively.

> This requires `superpowers` plug installed.


### Install
`/plugin marketplace add tim-hub/powerball`


---

Why create Superball?


`commands, skills, agents` all have different roles, this collection try to have the right balance of each, and also provide a variety of examples for different use cases. 


[Context cost by feature](https://code.claude.com/docs/en/features-overview#context-cost-by-feature)



Each feature has a different loading strategy and context cost:

| Feature         | When it loads             | What loads                                    | Context cost                                 |
| --------------- | ------------------------- | --------------------------------------------- | -------------------------------------------- |
| **CLAUDE.md**   | Session start             | Full content                                  | Every request                                |
| **Skills**      | Session start + when used | Descriptions at start, full content when used | Low (descriptions every request)*            |
| **MCP servers** | Session start             | All tool definitions and schemas              | Every request                                |
| **Subagents**   | When spawned              | Fresh context with specified skills           | Isolated from main session                   |
| **Hooks**       | On trigger                | Nothing (runs externally)                     | Zero, unless hook returns additional context |
