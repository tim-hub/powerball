#!/bin/bash
input=$(cat)
echo "$input" >> /tmp/statusline-debug.json

eval "$(echo "$input" | jq -r '@sh "MODEL=\(.model.display_name) DIR=\(.workspace.current_dir) COST=\(.cost.total_cost_usd // 0) PCT=\(.context_window.used_percentage // 0 | floor) DURATION_MS=\(.cost.total_duration_ms // 0) TRANSCRIPT=\(.transcript_path // "")"')"

REMOTE=$(git remote get-url origin 2>/dev/null | sed 's/git@\([^:]*\):/https:\/\/\1\//' | sed 's/\.git$//')
BRANCH=$(git rev-parse --git-dir > /dev/null 2>&1 && git branch --show-current 2>/dev/null || true)
STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

# ── Color palette (single source of truth) ────────────────────
c256()    { printf '\033[38;5;%sm%s\033[0m' "$1" "$2"; }
bold256() { printf '\033[1;38;5;%sm%s\033[0m' "$1" "$2"; }

RS='\033[0m'
# Line 1 — basic ANSI
C_MODEL='\033[36m'     C_COST='\033[33m'
C_BAR_OK='\033[32m'    C_BAR_WARN='\033[33m'    C_BAR_CRIT='\033[31m'
# Location
C_REPO='\033[1;38;5;252m'   C_COLON='\033[38;5;245m'
C_BRANCH='\033[38;5;81m'    C_STAGED='\033[38;5;82m'    C_MODIFIED='\033[38;5;214m'
# Line 2
C_PIPE='\033[38;5;238m'     C_IDLE='\033[38;5;252m'
N_SKILL=226   # bright yellow (used with c256/bold256)

# Tool → 256-color number
tool_color() {
    case "$1" in
        Bash)               echo 208 ;;  # orange     (shares MCP palette slot)
        Read)               echo 39  ;;  # sky blue   (shares C_BRANCH hue)
        Edit)               echo 82  ;;  # lime green (shares C_STAGED)
        Write)              echo 220 ;;  # gold       (shares C_COST hue)
        Grep)               echo 171 ;;  # orchid
        Glob)               echo 81  ;;  # steel blue (shares C_BRANCH)
        Agent)              echo 255 ;;  # bright white
        WebFetch|WebSearch) echo 159 ;;  # light cyan
        TodoWrite)          echo 244 ;;  # gray
        *)                  echo 250 ;;
    esac
}
MCP_PALETTE=(51 213 154 220 81 201 159 226 118 208)
# ─────────────────────────────────────────────────────────────

[ "$PCT" -ge 90 ] && BAR_COLOR="$C_BAR_CRIT" || { [ "$PCT" -ge 70 ] && BAR_COLOR="$C_BAR_WARN" || BAR_COLOR="$C_BAR_OK"; }
BAR=$(printf "%$((PCT / 10))s" | tr ' ' '█')$(printf "%$((10 - PCT / 10))s" | tr ' ' '░')

# Location: repo:branch or dir
if [ -n "$BRANCH" ]; then
    [ -n "$REMOTE" ] && REPO_RAW=$(basename "$REMOTE") || REPO_RAW="${DIR##*/}"
    [ -n "$REMOTE" ] && REPO_NAME="$(printf '%b' "\\e]8;;${REMOTE}\\a${REPO_RAW}\\e]8;;\\a")" || REPO_NAME="$REPO_RAW"
    BRANCH_DISPLAY="${BRANCH:0:12}"; [ ${#BRANCH} -gt 12 ] && BRANCH_DISPLAY="${BRANCH_DISPLAY}…"
    [ -n "$REMOTE" ] && BRANCH_DISPLAY="$(printf '%b' "\\e]8;;${REMOTE}/tree/${BRANCH}\\a${BRANCH_DISPLAY}\\e]8;;\\a")"
    LOCATION="🌿 ${C_REPO}${REPO_NAME}${RS}${C_COLON}:${RS}${C_BRANCH}${BRANCH_DISPLAY}${RS} ${C_STAGED}+${STAGED}${RS} ${C_MODIFIED}~${MODIFIED}${RS}"
else
    LOCATION="📁 ${C_REPO}${DIR##*/}${RS}"
fi

CC_VERSION=$(claude --version 2>/dev/null | awk '{print $1}')

# Line 1
printf "${C_MODEL}[%s]${RS} | %b | ${BAR_COLOR}%s${RS} %s%% | ${C_COST}%s${RS} | ⏱️ %dm %ds | ${C_MODEL}v%s${RS}\n" \
    "$MODEL" "$LOCATION" "$BAR" "$PCT" \
    "$(printf '$%.2f' "$COST")" "$((DURATION_MS / 60000))" "$(( (DURATION_MS % 60000) / 1000 ))" "$CC_VERSION"

# Line 2: tools, skills, MCP
if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
    PIPE=$(printf "${C_PIPE}  |  ${RS}")
    CACHE_DIR="$HOME/.claude/plugins/cache"

    TOOL_COUNTS=$(jq -r '
        select(.type=="assistant") |
        .message.content[]? |
        select(.type=="tool_use") |
        select(.name != "Skill") |
        select(.name | startswith("mcp__") | not) |
        .name' "$TRANSCRIPT" 2>/dev/null | sort | uniq -c | sort -rn | head -6)

    SKILLS=$(jq -r '
        select(.type=="assistant") |
        .message.content[]? |
        select(.type=="tool_use" and .name=="Skill") |
        .input.skill // empty' "$TRANSCRIPT" 2>/dev/null | awk '!seen[$0]++')

    MCP_USED=$(jq -r '
        select(.type=="assistant") |
        .message.content[]? |
        select(.type=="tool_use") |
        select(.name | startswith("mcp__")) |
        .name | split("__")[1]' "$TRANSCRIPT" 2>/dev/null \
        | sed 's/^plugin_[^_]*_//' | sort -u)

    MCP_CONNECTED=$(jq -r '.enabledPlugins | to_entries[] | select(.value==true) | .key' \
        "$HOME/.claude/settings.json" 2>/dev/null | while IFS='@' read -r plugin marketplace; do
        for f in "$CACHE_DIR/$marketplace/$plugin"/*/.mcp.json; do
            [ -f "$f" ] && jq -r '.mcpServers // {} | keys[]' "$f" 2>/dev/null
        done
    done | sort -u)

    ALL_MCP=$(printf '%s\n%s\n' "$MCP_CONNECTED" "$MCP_USED" | grep -v '^$' | sort -u)

    SECTIONS=()

    if [ -n "$TOOL_COUNTS" ]; then
        PARTS=""
        while read -r count name; do
            [ -z "$name" ] && continue
            [ "$count" -gt 1 ] && label="${name}×${count}" || label="$name"
            [ -n "$PARTS" ] && PARTS+="  "
            PARTS+=$(c256 "$(tool_color "$name")" "$label")
        done <<< "$TOOL_COUNTS"
        [ -n "$PARTS" ] && SECTIONS+=("🔧 $PARTS")
    fi

    if [ -n "$SKILLS" ]; then
        PARTS=""
        while IFS= read -r skill; do
            [ -z "$skill" ] && continue
            [ -n "$PARTS" ] && PARTS+="  "
            PARTS+=$(c256 "$N_SKILL" "$skill")
        done <<< "$SKILLS"
        [ -n "$PARTS" ] && SECTIONS+=("🎯 $PARTS")
    fi

    if [ -n "$ALL_MCP" ]; then
        PARTS=""; idx=0
        while IFS= read -r server; do
            [ -z "$server" ] && continue
            col="${MCP_PALETTE[$((idx % ${#MCP_PALETTE[@]}))]}"
            idx=$((idx + 1))
            [ -n "$PARTS" ] && PARTS+="  "
            if echo "$MCP_USED" | grep -qx "$server"; then
                PARTS+=$(bold256 "$col" "●$server")
            else
                PARTS+=$(printf "${C_IDLE}%s${RS}" "$server")
            fi
        done <<< "$ALL_MCP"
        [ -n "$PARTS" ] && SECTIONS+=("🔌 $PARTS")
    fi

    if [ "${#SECTIONS[@]}" -gt 0 ]; then
        OUTPUT=""
        for section in "${SECTIONS[@]}"; do
            [ -n "$OUTPUT" ] && OUTPUT+="$PIPE"
            OUTPUT+="$section"
        done
        printf '%s\n' "$OUTPUT"
    fi
fi
