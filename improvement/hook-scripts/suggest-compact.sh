#!/usr/bin/env bash
# PostToolUse(Edit|Write) hook: tracks tool calls per session and suggests
# /compact at configurable checkpoints.

THRESHOLD="${HARNESS_COMPACT_THRESHOLD:-50}"
INTERVAL="${HARNESS_COMPACT_INTERVAL:-25}"
SESSION_ID="${CLAUDE_SESSION_ID:-default}"

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
COUNTER_FILE="${PROJECT_ROOT}/.claude/state/compact-counter-${SESSION_ID}.txt"

mkdir -p "${PROJECT_ROOT}/.claude/state" 2>/dev/null || true

_count=$(( $(cat "${COUNTER_FILE}" 2>/dev/null || echo 0) + 1 ))
echo "${_count}" > "${COUNTER_FILE}"

_suggest=false
if [ "${_count}" -eq "${THRESHOLD}" ]; then
  _suggest=true
elif [ "${_count}" -gt "${THRESHOLD}" ] && [ "$(( (_count - THRESHOLD) % INTERVAL ))" -eq 0 ]; then
  _suggest=true
fi

if [ "${_suggest}" = "true" ]; then
  printf '{"systemMessage":"%d tool calls this session — consider `/compact` if transitioning phases or completing a milestone, for example finishing a planning session, or finishing a verification phase."}\n' "${_count}"
fi

exit 0
