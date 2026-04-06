#!/usr/bin/env bash
set -euo pipefail

# Install external skills via pnpx skills add.
# To add a new skill, append a line to the SKILLS array below.

SKILLS=(
  "https://github.com/chromedevtools/chrome-devtools-mcp --skill chrome-devtools-cli"
  "https://github.com/mblode/agent-skills --skill mermaid-mind-map"
)

installed=0
failed=0

for entry in "${SKILLS[@]}"; do
  echo "→ Installing: $entry"
  if pnpx skills add $entry -g -y --agent claude-code; then
    ((installed++))
  else
    echo "  ✗ Failed: $entry"
    ((failed++))
  fi
done

echo ""
echo "Skills install complete: $installed installed, $failed failed."
