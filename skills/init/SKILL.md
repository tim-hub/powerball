---
name: init
description: Initialize — set up statusline and install plugins. Invoke manually with /init.
disable-model-invocation: true
model: haiku
tools:
  allow:
    - Bash
hooks:
  Stop:
    - matcher: "*"
      hooks:
        - type: command
          command: bash "$CLAUDE_PLUGIN_ROOT/skills/init/scripts/done.sh"
          timeout: 120
---

Run the following in order:

1. Make all scripts executable:
```bash
chmod +x "$CLAUDE_PLUGIN_ROOT/skills/init/scripts/"*.sh
```

2. Set up CLAUDE.md:
```bash
bash "$CLAUDE_PLUGIN_ROOT/skills/init/scripts/init-claude-md.sh"
```

3. Set up statusline:
```bash
bash "$CLAUDE_PLUGIN_ROOT/skills/init/scripts/init-statusline.sh"
```

4. Set up plugins:
```bash
bash "$CLAUDE_PLUGIN_ROOT/skills/init/scripts/set-up-plugins.sh"
```

Report the output of each step, then stop.
