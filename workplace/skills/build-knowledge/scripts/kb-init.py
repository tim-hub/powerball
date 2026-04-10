#!/usr/bin/env python3
"""Initialize knowledge base config.

Usage:
    kb-init.py [knowledge_base_path]

If .powerball/workplace-config.json doesn't exist, creates it.
If a path argument is provided, sets knowledge_base_path in the config.
Outputs the resolved knowledge_base_path to stdout.

Exit codes:
    0 — success, path is configured and printed
    1 — config exists but knowledge_base_path is not set (needs user input)
"""

import json
import os
import sys
import subprocess

CONFIG_DIR = ".powerball"
CONFIG_FILE = os.path.join(CONFIG_DIR, "workplace-config.json")


def main():
    os.makedirs(CONFIG_DIR, exist_ok=True)

    if not os.path.isfile(CONFIG_FILE):
        with open(CONFIG_FILE, "w") as f:
            json.dump({}, f)

    with open(CONFIG_FILE) as f:
        config = json.load(f)

    # If a path argument was provided, write it to config
    if len(sys.argv) >= 2 and sys.argv[1]:
        kb_path = os.path.expanduser(sys.argv[1])
        kb_path = os.path.abspath(kb_path)

        config["knowledge_base_path"] = kb_path
        with open(CONFIG_FILE, "w") as f:
            json.dump(config, f, indent=2)

        os.makedirs(kb_path, exist_ok=True)
        print(kb_path)
        return 0

    # No argument — read existing config
    kb_path = config.get("knowledge_base_path", "")
    if not kb_path:
        return 1

    print(kb_path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
