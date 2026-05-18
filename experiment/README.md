# experiment

Sandbox plugin for trying new hooks and skills before promoting them to a stable plugin.

## Prerequisites

The `/optimize-skill` skill must be installed from the marketplace. The `optimize-skill-reminder` hook fires automatically when you edit any skill file and will invoke `/optimize-skill` — without it, the directive silently does nothing.

```
/plugin marketplace add <source>
```

## Skills

- **optimize-skill-reminder** — companion doc for the PostToolUse hook; explains how the hook works and how to disable it.
