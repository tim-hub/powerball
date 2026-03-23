#!/bin/bash
# Set up default Claude Code settings in ~/.claude/settings.json if not already configured

SETTINGS="$HOME/.claude/settings.json"

# Ensure jq is available
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required but not installed. Install it with: brew install jq"
  exit 1
fi

# Ensure ~/.claude directory exists
mkdir -p "$HOME/.claude"

# Create settings.json if it doesn't exist
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
  echo "Created: $SETTINGS"
fi

# Set env vars if not present
if jq -e '.env.CLAUDE_CODE_ENABLE_TELEMETRY' "$SETTINGS" &>/dev/null; then
  echo "Skipped: env.CLAUDE_CODE_ENABLE_TELEMETRY (already configured)"
else
  jq '.env.CLAUDE_CODE_ENABLE_TELEMETRY = "0"' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  echo "Added: env.CLAUDE_CODE_ENABLE_TELEMETRY = 0"
fi

if jq -e '.env.DISABLE_AUTOUPDATER' "$SETTINGS" &>/dev/null; then
  echo "Skipped: env.DISABLE_AUTOUPDATER (already configured)"
else
  jq '.env.DISABLE_AUTOUPDATER = "1"' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  echo "Added: env.DISABLE_AUTOUPDATER = 1"
fi

# Set attribution if not present
if jq -e '.attribution' "$SETTINGS" &>/dev/null; then
  echo "Skipped: attribution (already configured)"
else
  jq '.attribution = {"commit": "", "pr": ""}' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  echo "Added: attribution (commit, pr)"
fi

# Set defaultMode if not present
if jq -e '.defaultMode' "$SETTINGS" &>/dev/null; then
  echo "Skipped: defaultMode (already configured)"
else
  jq '.defaultMode = "acceptEdits"' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  echo "Added: defaultMode = acceptEdits"
fi

# Set sandbox if not present
if jq -e '.sandbox' "$SETTINGS" &>/dev/null; then
  echo "Skipped: sandbox (already configured)"
else
  jq '.sandbox = {"enabled": true}' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  echo "Added: sandbox (enabled)"
fi

# Set permissions if not present
if jq -e '.permissions' "$SETTINGS" &>/dev/null; then
  echo "Skipped: permissions (already configured)"
else
  jq '.permissions = {"allow": ["Bash", "WebFetch", "WebSearch", "Read", "Search", "Edit", "TodoWrite(**)", "Task(**)"]}' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  echo "Added: permissions (allow list)"
fi

# Set showClearContextOnPlanAccept if not present
if jq -e '.showClearContextOnPlanAccept' "$SETTINGS" &>/dev/null; then
  echo "Skipped: showClearContextOnPlanAccept (already configured)"
else
  jq '.showClearContextOnPlanAccept = true' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  echo "Added: showClearContextOnPlanAccept = true"
fi
