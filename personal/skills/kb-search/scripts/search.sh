#!/usr/bin/env bash
# search.sh — Search across allowed paths using ripgrep, respecting disallow list
# Usage: search.sh <keyword> <allow_list_json> <disallow_list_json>

set -euo pipefail

KEYWORD="$1"
ALLOW_LIST_JSON="$2"
DISALLOW_LIST_JSON="${3:-[]}"

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

EXCLUDE_ARGS=()
for disallowed in "${DISALLOW_PATHS[@]}"; do
  [ -n "$disallowed" ] && EXCLUDE_ARGS+=("--glob" "!${disallowed}/**")
done

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

for search_path in "${ALLOW_PATHS[@]}"; do
  [ -d "$search_path" ] && rg "${RG_OPTS[@]}" "$KEYWORD" "$search_path" 2>/dev/null || true
done
