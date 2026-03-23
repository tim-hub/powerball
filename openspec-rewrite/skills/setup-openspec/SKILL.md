---
name: setup-openspec
description: Initializes OpenSpec in a project by copying config and schemas from the powerball templates. Use when the user asks to "set up openspec", "init openspec", "install openspec templates", or "initialize openspec" in a project.
user-invocable: true
disable-model-invocation: true
model: haiku
allowed-tools: Bash, Read, Write, Edit
---

Run the following steps in order from the project root:

**Step 1 — Check OpenSpec is installed:**
```bash
openspec --version 2>/dev/null && echo "installed" || echo "missing"
```

If missing, install it:
```bash
pnpm install -g @fission-ai/openspec@latest
```

**Step 2 — Apply powerball templates (overrides config and schemas):**
```bash
bash <skill-dir>/scripts/setup.sh <project-root>
```

Where `<skill-dir>` is the directory containing this SKILL.md and `<project-root>` is the project root (defaults to current directory).

The script copies `config.yaml` and `schemas/` from the skill's `templates/` folder into `<project-root>/openspec/`, overwriting the defaults created by `openspec init`.

**Step 3 — Disable OpenSpec telemetry:**
```bash
bash <skill-dir>/scripts/disable-openspec-telemetry.sh
```

After all steps complete, confirm success and let the user know they can customize `openspec/config.yaml` to select a schema.
