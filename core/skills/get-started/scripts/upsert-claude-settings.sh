#!/bin/bash
# Set up default Claude Code settings in ~/.claude/settings.json if not already configured.
# Edit desired-settings.json to add/change settings — this script loads and upserts them.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SETTINGS="$HOME/.claude/settings.json"
DESIRED="$SCRIPT_DIR/desired-settings.json"

# Ensure jq is available
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required but not installed. Install it with: brew install jq"
  exit 1
fi

# Ensure desired-settings.json exists
if [ ! -f "$DESIRED" ]; then
  echo "Error: $DESIRED not found"
  exit 1
fi

# Ensure ~/.claude directory exists
mkdir -p "$HOME/.claude"

# Create settings.json if it doesn't exist
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
  echo "Created: $SETTINGS"
fi

# Iterate over each top-level key in desired-settings.json and upsert if missing
for key in $(jq -r 'keys[]' "$DESIRED"); do
  value=$(jq -c --arg k "$key" '.[$k]' "$DESIRED")

  if jq -e --arg k "$key" '.[$k]' "$SETTINGS" &>/dev/null; then
    echo "Skipped: $key (already configured)"
  else
    jq --arg k "$key" --argjson v "$value" '.[$k] = $v' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
    echo "Added: $key"
  fi
done
