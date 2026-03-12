#!/bin/bash
input=$(cat)
echo "$input" >> /tmp/statusline-debug.json

# Single jq call to extract all fields at once
eval "$(echo "$input" | jq -r '@sh "MODEL=\(.model.display_name) DIR=\(.workspace.current_dir) COST=\(.cost.total_cost_usd // 0) PCT=\(.context_window.used_percentage // 0 | floor) DURATION_MS=\(.cost.total_duration_ms // 0)"')"

REMOTE=$(git remote get-url origin 2>/dev/null | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/\.git$//')
BRANCH=$(git rev-parse --git-dir > /dev/null 2>&1 && git branch --show-current 2>/dev/null || true)
STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

# Colors and bar
CYAN='\033[36m'; YELLOW='\033[33m'; GREEN='\033[32m'; RED='\033[31m'; RESET='\033[0m'
[ "$PCT" -ge 90 ] && BAR_COLOR="$RED" || { [ "$PCT" -ge 70 ] && BAR_COLOR="$YELLOW" || BAR_COLOR="$GREEN"; }
BAR=$(printf "%$((PCT / 10))s" | tr ' ' '█')$(printf "%$((10 - PCT / 10))s" | tr ' ' '░')

# Location: show repo:branch in git repos, dir otherwise
if [ -n "$BRANCH" ]; then
    [ -n "$REMOTE" ] && REPO_NAME="$(printf '%b' "\\e]8;;${REMOTE}\\a$(basename "$REMOTE")\\e]8;;\\a")" || REPO_NAME="${DIR##*/}"
    LOCATION="🌿 ${REPO_NAME}:${BRANCH} +${STAGED} ~${MODIFIED}"
else
    LOCATION="📁 ${DIR##*/}"
fi

CC_VERSION=$(claude --version 2>/dev/null | awk '{print $1}')
printf "${CYAN}[%s]${RESET} | %s | ${BAR_COLOR}%s${RESET} %s%% | ${YELLOW}%s${RESET} | ⏱️ %dm %ds | ${CYAN}v%s${RESET}\n" \
    "$MODEL" "$LOCATION" "$BAR" "$PCT" \
    "$(printf '$%.2f' "$COST")" "$((DURATION_MS / 60000))" "$(( (DURATION_MS % 60000) / 1000 ))" "$CC_VERSION"
