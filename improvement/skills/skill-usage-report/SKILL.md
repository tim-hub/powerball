---
name: skill-usage-report
description: "Shows a report of skill invocations and usage frequency. Use when reviewing which skills are being used."
when_to_use: "skill usage report, show skill stats, which skills am I using, skill summary, how often are skills used"
user-invocable: true
model: haiku
disable-model-invocation: true
allowed-tools: Bash
---

Run the skill usage report and display the output:

```bash
python3 "$CLAUDE_PLUGIN_ROOT/skills/skill-usage-report/report.py"
```

Display the output verbatim. If the script exits with no output, say "No skill usage log found at ~/.claude/skill-usage.log — skills have not been logged yet."
