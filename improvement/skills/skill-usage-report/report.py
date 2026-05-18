#!/usr/bin/env python3
"""SessionStart hook: prints a skill usage summary."""

import os
import sys
from collections import Counter
from datetime import datetime, timedelta, timezone

LOG = os.path.expanduser("~/.claude/skill-usage.log")

if not os.path.exists(LOG):
    sys.exit(0)

entries = []
with open(LOG) as f:
    for line in f:
        parts = line.split(None, 3)
        if len(parts) < 3:
            continue
        try:
            dt = datetime.fromtimestamp(int(parts[0]), tz=timezone.utc)
            entries.append((dt, parts[2]))
        except (ValueError, OSError):
            continue

if not entries:
    sys.exit(0)

now = datetime.now(timezone.utc)

def top(since, n=8):
    return Counter(s for dt, s in entries if dt >= since).most_common(n)

def render_section(label, rows):
    if not rows:
        return
    max_count = rows[0][1]
    print(f"\n  {label}")
    for skill, count in rows:
        bar = "▪" * min(round(count / max_count * 20), 20)
        print(f"    {skill:<42} {bar} {count}")

print(f"\n┌─ Skill Usage Report · {now.strftime('%Y-%m-%d')} ──────────────────────")
render_section("Last 24 h", top(now - timedelta(days=1)))
render_section("Last 7 days", top(now - timedelta(days=7)))
render_section("All time", top(datetime.min.replace(tzinfo=timezone.utc)))
print(f"\n  Total invocations logged: {len(entries)}")
print("└────────────────────────────────────────────────────\n")
