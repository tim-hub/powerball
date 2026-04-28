#!/usr/bin/env bash
set -euo pipefail

# Install external skills via pnpx skills add.
# To add a new skill, append a line to the SKILLS array below.

SKILLS=(
  "https://github.com/chromedevtools/chrome-devtools-mcp --skill chrome-devtools-cli"
  "https://github.com/mblode/agent-skills --skill mermaid-mind-map"
)

MATTPOCOCK_SKILLS=(
  grill-me
  tdd
  improve-codebase-architecture
  write-a-prd
  write-a-skill
  prd-to-issues
  to-prd
  to-issues
  prd-to-plan
  triage-issue
  caveman
  setup-pre-commit
  zoom-out
  edit-article
  github-triage
  scaffold-exercises
  grill-with-docs
  domain-model
  triage
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

skill_flags=""
for s in "${MATTPOCOCK_SKILLS[@]}"; do
  skill_flags="$skill_flags --skill $s"
done

echo "→ Installing: mattpocock/skills"
if pnpx skills add https://github.com/mattpocock/skills $skill_flags -g -y --agent claude-code; then
  ((installed++))
else
  echo "  ✗ Failed: mattpocock/skills"
  ((failed++))
fi

echo ""
echo "Skills install complete: $installed installed, $failed failed."
