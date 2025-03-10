#!/bin/bash
# Copy template CLAUDE.md to ~/.claude/CLAUDE.md

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/../templates/CLAUDE.md"
DEST="$HOME/.claude/CLAUDE.md"

if [ -f "$DEST" ]; then
  read -r -p "~/.claude/CLAUDE.md already exists. Override? (y/N): " answer
  if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    cp "$SOURCE" "$DEST"
    echo "  ✓ Overridden: $DEST"
  else
    echo "  Skipped: $DEST"
  fi
else
  cp "$SOURCE" "$DEST"
  echo "  ✓ Installed: $DEST"
fi
