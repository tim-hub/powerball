#!/usr/bin/env bash
set -euo pipefail

# Install rule sets from everything-claude-code via degit.
# Each entry: "repo-subpath destination-dir"

COMMON="affaan-m/everything-claude-code/rules/common"
COMMON_DEST="~/.claude/rules/pb/common"

RULES=(
  "${COMMON}/code-review.md            ${COMMON_DEST}/code-review.md"
  "${COMMON}/coding-style.md           ${COMMON_DEST}/coding-style.md"
  "${COMMON}/development-workflow.md   ${COMMON_DEST}/development-workflow.md"
  "${COMMON}/git-workflow.md           ${COMMON_DEST}/git-workflow.md"
  "${COMMON}/hooks.md                  ${COMMON_DEST}/hooks.md"
  "${COMMON}/patterns.md               ${COMMON_DEST}/patterns.md"
  "${COMMON}/performance.md            ${COMMON_DEST}/performance.md"
  "${COMMON}/security.md               ${COMMON_DEST}/security.md"
  "${COMMON}/testing.md                ${COMMON_DEST}/testing.md"
  "affaan-m/everything-claude-code/rules/golang     ~/.claude/rules/pb/golang"
  "affaan-m/everything-claude-code/rules/typescript ~/.claude/rules/pb/typescript"
  "affaan-m/everything-claude-code/rules/python     ~/.claude/rules/pb/python"
  "affaan-m/everything-claude-code/rules/swift      ~/.claude/rules/pb/swift"
  "affaan-m/everything-claude-code/rules/web        ~/.claude/rules/pb/web"
  "affaan-m/everything-claude-code/rules/kotlin     ~/.claude/rules/pb/kotlin"
)

installed=0
failed=0

for entry in "${RULES[@]}"; do
  src="${entry%% *}"
  dest="${entry##* }"
  dest="${dest/#\~/$HOME}"

  echo "→ Installing: $src → $dest"
  mkdir -p "$(dirname "$dest")"
  if pnpx degit "$src" "$dest" --force; then
    ((installed++))
  else
    echo "  ✗ Failed: $src"
    ((failed++))
  fi
done

echo ""
echo "Rules install complete: $installed installed, $failed failed."
