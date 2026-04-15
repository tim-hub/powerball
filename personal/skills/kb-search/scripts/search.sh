#!/usr/bin/env bash
# search.sh — Search across allowed paths using ripgrep, respecting disallow list
# Usage: search.sh <keyword> <allow_list_json> <disallow_list_json>
#
# allow_list_json  — JSON array of directory paths to search, e.g. '["/home/user/notes"]'
# disallow_list_json — JSON array of paths to exclude, e.g. '["/home/user/notes/archive"]'
#
# Outputs: matching lines with file path, line number, and surrounding context

set -euo pipefail

KEYWORD="$1"
ALLOW_LIST_JSON="$2"
DISALLOW_LIST_JSON="${3:-[]}"

# Parse allow_list and disallow_list via jq (while-read for bash 3.2 compat)
ALLOW_PATHS=()
while IFS= read -r line; do
  [ -n "$line" ] && ALLOW_PATHS+=("$line")
done < <(jq -r '.[]' <<< "$ALLOW_LIST_JSON")

DISALLOW_PATHS=()
while IFS= read -r line; do
  [ -n "$line" ] && DISALLOW_PATHS+=("$line")
done < <(jq -r '.[]' <<< "$DISALLOW_LIST_JSON")

if [ ${#ALLOW_PATHS[@]} -eq 0 ]; then
  echo "ERROR: allow_list is empty. Run kb-setup first." >&2
  exit 1
fi

# Build ripgrep exclude args from disallow_list
EXCLUDE_ARGS=()
for disallowed in "${DISALLOW_PATHS[@]}"; do
  if [ -n "$disallowed" ]; then
    EXCLUDE_ARGS+=("--glob" "!${disallowed}/**")
  fi
done

# Common ripgrep options: case-insensitive, with context lines, max 20 results
RG_OPTS=(
  --ignore-case
  --context 2
  --max-count 20
  --type-add "md:*.md"
  --type md
  --no-heading
  --line-number
  "${EXCLUDE_ARGS[@]+"${EXCLUDE_ARGS[@]}"}"
)

# Search across all allowed paths
for search_path in "${ALLOW_PATHS[@]}"; do
  if [ -d "$search_path" ]; then
    rg "${RG_OPTS[@]}" "$KEYWORD" "$search_path" 2>/dev/null || true
  fi
done
