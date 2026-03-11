#!/bin/bash
# Initialize Claude Code status line
# Copies statusline-command.sh to ~/.claude/ and configures settings.json
# Unconditional — caller (SKILL.md) handles existence check and user confirmation.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SOURCE="$SCRIPT_DIR/powerball-statusline-command.sh"
DEST="$CLAUDE_DIR/statusline-command.sh"

if [ ! -f "$SOURCE" ]; then
  echo "Error: source not found: $SOURCE" >&2
  exit 1
fi

mkdir -p "$CLAUDE_DIR"

# Copy the statusline script
cp "$SOURCE" "$DEST"
chmod +x "$DEST"
echo "  ✓ Installed: $DEST"
