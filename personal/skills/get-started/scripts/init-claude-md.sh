#!/bin/bash
# Copy template CLAUDE.md and its references/ tree to ~/.claude/.
# Unconditional — caller (SKILL.md) handles existence check and user confirmation.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/../templates"
SOURCE="$TEMPLATES_DIR/CLAUDE.md"
DEST="$HOME/.claude/CLAUDE.md"
REFS_SOURCE="$TEMPLATES_DIR/references"
REFS_DEST="$HOME/.claude/references"

if [ ! -f "$SOURCE" ]; then
  echo "Error: template not found: $SOURCE" >&2
  exit 1
fi

mkdir -p "$(dirname "$DEST")"
cp "$SOURCE" "$DEST"
echo "  ✓ Installed: $DEST"

if [ -d "$REFS_SOURCE" ]; then
  mkdir -p "$REFS_DEST"
  cp -R "$REFS_SOURCE/." "$REFS_DEST/"
  echo "  ✓ Installed: $REFS_DEST/"
fi
