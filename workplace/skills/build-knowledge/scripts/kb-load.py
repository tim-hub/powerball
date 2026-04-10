#!/usr/bin/env python3
"""Load knowledge base config and resolve project path.

Usage:
    kb-load.py [project_name]

Reads .powerball/workplace-config.json and outputs JSON with resolved paths.
If project_name is omitted, derives it from git remote or directory basename.

Output (JSON to stdout):
    { "kb_path": "...", "project": "...", "project_path": "...", "has_entries": true/false }

Exit codes:
    0 — success
    1 — config not found or knowledge_base_path not set (silent skip)
"""

import json
import os
import subprocess
import sys

CONFIG_FILE = ".powerball/workplace-config.json"


def get_project_name():
    """Derive project name from git remote, falling back to cwd basename."""
    try:
        url = subprocess.check_output(
            ["git", "remote", "get-url", "origin"],
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
        name = url.rstrip("/").rsplit("/", 1)[-1]
        if name.endswith(".git"):
            name = name[:-4]
        if name:
            return name
    except (subprocess.CalledProcessError, FileNotFoundError):
        pass
    return os.path.basename(os.getcwd())


def main():
    if not os.path.isfile(CONFIG_FILE):
        return 1

    try:
        with open(CONFIG_FILE) as f:
            config = json.load(f)
    except (json.JSONDecodeError, OSError):
        return 1

    kb_path = config.get("knowledge_base_path", "")
    if not kb_path or not os.path.isdir(kb_path):
        return 1

    project = sys.argv[1] if len(sys.argv) >= 2 and sys.argv[1] else get_project_name()
    project_path = os.path.join(kb_path, project)

    print(json.dumps({
        "kb_path": kb_path,
        "project": project,
        "project_path": project_path,
        "has_entries": os.path.isdir(project_path) and len(os.listdir(project_path)) > 0,
    }))
    return 0


if __name__ == "__main__":
    sys.exit(main())
