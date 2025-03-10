#!/usr/bin/env bash
# Claude Code status line
# Format: agent(model), folder, (added+, removed-) ctx% [bar], $cost, vX.Y.Z
# Reads JSON from stdin and outputs a single formatted line

input=$(cat)

# Extract fields
agent_name=$(echo "$input" | jq -r '.agent.name // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
version=$(echo "$input" | jq -r '.version // empty')

# Token / context data
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
cache_write=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')

# Current folder (basename only)
dir=$(basename "$cwd")

# ANSI colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Agent(Model) ────────────────────────────────────────────────────────────
if [ -n "$agent_name" ]; then
  label="${agent_name}(${model})"
else
  label="${model}"
fi

# ── Lines added / removed (approximated from token deltas) ──────────────────
# Use total_output as a proxy for lines added, total_input as lines consumed.
# Displayed in the spirit of a diff summary; values are token counts.
lines_added="$total_output"
lines_removed="$total_input"

# ── Context progress bar (10 chars wide) ────────────────────────────────────
bar=""
if [ -n "$used_pct" ] && [ "$used_pct" != "null" ]; then
  used_int=${used_pct%.*}
  filled=$(( used_int / 10 ))
  empty=$(( 10 - filled ))
  for ((i=0; i<filled; i++)); do bar+="█"; done
  for ((i=0; i<empty; i++)); do  bar+="░"; done
  # Color bar red when >= 80%
  if [ "$used_int" -ge 80 ] 2>/dev/null; then
    ctx_color="$RED"
  else
    ctx_color="$GREEN"
  fi
  ctx_display="${used_int}%"
else
  bar="░░░░░░░░░░"
  ctx_color="$DIM"
  ctx_display="n/a"
fi

# ── Cost estimate (input tokens * ~$3/M + output tokens * ~$15/M) ───────────
# Using claude-sonnet pricing as default approximation
cost=$(awk "BEGIN {
  input_cost  = $total_input  * 3.0  / 1000000;
  output_cost = $total_output * 15.0 / 1000000;
  printf \"\$%.4f\", input_cost + output_cost
}")

# ── Assemble one line ────────────────────────────────────────────────────────
printf "%b" \
  "$(printf "${BOLD}${CYAN}%s${RESET}" "$label")" \
  "$(printf "${DIM}, ${RESET}")" \
  "$(printf "${YELLOW}%s${RESET}" "$dir")" \
  "$(printf "${DIM} (${RESET}")" \
  "$(printf "${GREEN}%s+${RESET}" "$lines_added")" \
  "$(printf "${DIM}, ${RESET}")" \
  "$(printf "${RED}%s-${RESET}" "$lines_removed")" \
  "$(printf "${DIM}) ${RESET}")" \
  "$(printf "${ctx_color}%s [%s]${RESET}" "$ctx_display" "$bar")" \
  "$(printf "${DIM}, ${RESET}")" \
  "$(printf "${MAGENTA}%s${RESET}" "$cost")" \
  "$(printf "${DIM}, ${RESET}")" \
  "$(printf "${DIM}v%s${RESET}" "$version")"
