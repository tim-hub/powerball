#!/usr/bin/env bash
# init.sh — Initialize or update ~/.kb/config.json
# Usage:
#   init.sh reset                          — write empty config
#   init.sh <allow_json> <disallow_json>   — write full config
#
# allow_json    — JSON array string, e.g. '["/Users/me/notes"]'
# disallow_json — JSON array string, e.g. '["/Users/me/notes/archive"]'

set -euo pipefail

CONFIG_DIR="$HOME/.kb"
CONFIG_FILE="$CONFIG_DIR/config.json"

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

if [ "${1:-}" = "reset" ]; then
  echo '{"allow_list": [], "disallow_list": []}' > "$CONFIG_FILE"
  echo "reset:$CONFIG_FILE"
  exit 0
fi

ALLOW_LIST_JSON="${1:-[]}"
DISALLOW_LIST_JSON="${2:-[]}"

# Write config using jq to ensure valid JSON
jq -n \
  --argjson allow "$ALLOW_LIST_JSON" \
  --argjson disallow "$DISALLOW_LIST_JSON" \
  '{"allow_list": $allow, "disallow_list": $disallow}' > "$CONFIG_FILE"

echo "saved:$CONFIG_FILE"

# Create the kb/ subfolder inside allow_list[0] if it exists
FIRST_ALLOW=$(jq -r '.[0] // empty' <<< "$ALLOW_LIST_JSON")
if [ -n "$FIRST_ALLOW" ]; then
  KB_DIR="$FIRST_ALLOW/kb"
  mkdir -p "$KB_DIR"
  echo "kb-dir:$KB_DIR"
fi
