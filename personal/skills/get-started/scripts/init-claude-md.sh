#!/bin/bash
# Copy template CLAUDE.md to ~/.claude/CLAUDE.md
# Unconditional — caller (SKILL.md) handles existence check and user confirmation.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/../templates/CLAUDE.md"
DEST="$HOME/.claude/CLAUDE.md"

if [ ! -f "$SOURCE" ]; then
  echo "Error: template not found: $SOURCE" >&2
  exit 1
fi

mkdir -p "$(dirname "$DEST")"
cp "$SOURCE" "$DEST"
echo "  ✓ Installed: $DEST"
