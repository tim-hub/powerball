#!/usr/bin/env bash
# upsert.sh — Add or update a section in a KB markdown file
# Usage: upsert.sh <kb-file-path> <topic> <tags> <content>
#
# tags    — space-separated hashtags, e.g. "#claude #performance"
#           pass "" to omit tags
#
# - Creates the file from template if it doesn't exist
# - Uses ripgrep to detect if the topic section already exists
# - Appends a new section or appends content under an existing one

set -euo pipefail

KB_FILE="$1"
TOPIC="$2"
TAGS="${3:-}"
CONTENT="$4"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/../templates/kb.template.md"
KB_DIR="$(dirname "$KB_FILE")"
PROJECT_NAME="$(basename "$KB_FILE" .md)"

# Ensure KB directory exists
mkdir -p "$KB_DIR"

TODAY="$(date '+%Y-%m-%d')"

# Create from template if file doesn't exist
if [ ! -f "$KB_FILE" ]; then
  sed "s/{{project}}/$PROJECT_NAME/g; s/{{date}}/$TODAY/g" "$TEMPLATE" > "$KB_FILE"
else
  # Refresh the _Last updated_ line
  sed -i '' "s/_Last updated: .*_/_Last updated: ${TODAY}_/" "$KB_FILE" 2>/dev/null || true
fi

# Check if a section with this topic already exists (case-insensitive heading match)
ESCAPED_TOPIC=$(printf '%s' "$TOPIC" | sed 's/[.[\*^$]/\\&/g')
EXISTING_LINE=$(rg -in "^##\s+$ESCAPED_TOPIC" "$KB_FILE" -n --no-filename 2>/dev/null | head -1 || true)

if [ -n "$EXISTING_LINE" ]; then
  # Topic exists — append new content under existing heading
  LINE_NUM=$(echo "$EXISTING_LINE" | cut -d: -f1)
  # Find the next section heading after this line (to know where section ends)
  NEXT_SECTION=$(awk "NR > $LINE_NUM && /^##[^#]/" "$KB_FILE" | head -1)
  if [ -n "$NEXT_SECTION" ]; then
    NEXT_LINE=$(rg -n "^$(printf '%s' "$NEXT_SECTION" | head -c 30 | sed 's/[.[\*^$]/\\&/g')" "$KB_FILE" | head -1 | cut -d: -f1)
    INSERT_AT=$((NEXT_LINE - 1))
  else
    # No next section, insert at end of file
    INSERT_AT=$(wc -l < "$KB_FILE")
  fi
  # Insert the content lines before next section (or at end), with an updated-at marker
  TEMP_FILE=$(mktemp)
  awk -v insert_at="$INSERT_AT" -v content="$CONTENT" -v today="$TODAY" '
    NR == insert_at { print ""; print "_Updated: " today "_"; print ""; print content }
    { print }
  ' "$KB_FILE" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$KB_FILE"
  echo "updated:$LINE_NUM"
else
  # Topic does not exist — append new section at end of file
  if [ -n "$TAGS" ]; then
    printf '\n## %s\n\n%s\n\n_Updated: %s_\n\n%s\n' "$TOPIC" "$TAGS" "$TODAY" "$CONTENT" >> "$KB_FILE"
  else
    printf '\n## %s\n\n_Updated: %s_\n\n%s\n' "$TOPIC" "$TODAY" "$CONTENT" >> "$KB_FILE"
  fi
  echo "created"
fi
