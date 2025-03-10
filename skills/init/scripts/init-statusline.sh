#!/bin/bash
# Initialize Claude Code status line
# Copies statusline-command.sh to ~/.claude/ and configures settings.json

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SOURCE="$SCRIPT_DIR/powerball-statusline-command.sh"
DEST="$CLAUDE_DIR/statusline-command.sh"
SETTINGS="$CLAUDE_DIR/settings.json"

# Copy the statusline script
if [ -f "$DEST" ]; then
  read -r -p "statusline-command.sh already exists. Override? (y/N): " answer
  if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    cp "$SOURCE" "$DEST"
    chmod +x "$DEST"
    echo "  ✓ Overridden: $DEST"
  else
    echo "  Skipped: $DEST"
  fi
else
  cp "$SOURCE" "$DEST"
  chmod +x "$DEST"
  echo "  ✓ Installed: $DEST"
fi

# Update settings.json
if [ ! -f "$SETTINGS" ]; then
  echo "Creating $SETTINGS..."
  echo '{}' > "$SETTINGS"
fi

echo "Updating statusLine in settings.json..."
UPDATED=$(jq '. + {"statusLine": {"type": "command", "command": "bash ~/.claude/statusline-command.sh"}}' "$SETTINGS")
echo "$UPDATED" > "$SETTINGS"
echo "  ✓ statusLine configured"

echo "Done."
