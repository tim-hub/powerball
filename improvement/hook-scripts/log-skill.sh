#!/bin/bash
# PreToolUse hook — logs every Skill invocation to ~/.claude/skill-usage.log
# stdin: { tool_name, tool_input: { skill, args }, session_id, ... }

command -v jq >/dev/null || exit 0
payload=$(cat)
skill=$(jq -r '.tool_input.skill' <<< "$payload")
args=$(jq -r '.tool_input.args // ""' <<< "$payload")

echo "$(date -u +%s)  $USER  $skill  $args" >> ~/.claude/skill-usage.log
