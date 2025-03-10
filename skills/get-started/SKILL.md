---
name: get-started
description: Initialize claude code settings — set up statusline, global CLAUDE.md and install plugins. Triggered by requests like "set up claude code", "initialize plugins", "get started", or "run setup".
model: haiku
tools:
  allow:
    - Bash
  deny:
    - WebFetch
    - Fetch
hooks:
  Stop:
    - matcher: "*"
      hooks:
        - type: command
          command: bash "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/done.sh"
          timeout: 120
---

Run the following in order:

1. Make all scripts executable:
```bash
chmod +x "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/"*.sh
```

2. Set up CLAUDE.md:
```bash
bash "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/init-claude-md.sh"
```

3. Set up statusline:
```bash
bash "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/init-statusline.sh"
```

4. Set up plugins:
```bash
bash "$CLAUDE_PLUGIN_ROOT/skills/get-started/scripts/set-up-plugins.sh"
```

Report the output of each step, then stop.
