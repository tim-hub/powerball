#!/usr/bin/env bash
set -euo pipefail

# Sync Claude Code skills to the desired state.
# Installs missing skills and removes unlisted pnpx-managed ones.
# Plugin-installed skills (not managed by pnpx) are left untouched.

MATTPOCOCK_SKILLS=(
  grill-me
  # tdd
  # improve-codebase-architecture
  # write-a-prd
  # write-a-skill
  # prd-to-issues
  # to-prd
  # to-issues
  # prd-to-plan
  # triage-issue
  # caveman
  # setup-pre-commit
  zoom-out
  # edit-article
  # github-triage
  # scaffold-exercises
  grill-with-docs
  # domain-model
  # triage
)

SKILLS=(
  # "https://github.com/chromedevtools/chrome-devtools-mcp --skill chrome-devtools-cli"
  # "https://github.com/mblode/agent-skills --skill mermaid-mind-map"
  # "https://github.com/jakubkrehel/make-interfaces-feel-better"
)

# pnpx-managed skills in ~/.claude/skills/ (strip ANSI codes, grab name from path lines)
installed=$(pnpx skills list -g --agent claude-code 2>/dev/null \
  | sed 's/\x1b\[[0-9;]*m//g' \
  | grep "~/.claude/skills/" \
  | awk '{print $1}')

to_remove=()
to_install=()

while IFS= read -r name; do
  [[ -z "$name" ]] && continue
  if ! printf '%s\n' "${MATTPOCOCK_SKILLS[@]}" | grep -qx "$name"; then
    to_remove+=("$name")
  fi
done <<< "$installed"

for skill in "${MATTPOCOCK_SKILLS[@]}"; do
  if ! echo "$installed" | grep -qx "$skill"; then
    to_install+=("$skill")
  fi
done

if [[ ${#to_remove[@]} -eq 0 && ${#to_install[@]} -eq 0 ]]; then
  echo "✔ Skills already in sync."
  exit 0
fi

echo ""
for s in "${to_remove[@]}";  do echo "  - remove:  $s"; done
for s in "${to_install[@]}"; do echo "  + install: $s"; done
echo ""

read -r -p "Apply changes? (y/N): " answer
[[ "$answer" != "y" && "$answer" != "Y" ]] && { echo "Skipped."; exit 0; }

for skill in "${to_remove[@]}"; do
  echo "Removing $skill..."
  pnpx skills remove "$skill" -g --agent claude-code
done

if [[ ${#to_install[@]} -gt 0 ]]; then
  skill_flags=""
  for s in "${to_install[@]}"; do
    skill_flags="$skill_flags --skill $s"
  done
  echo "Installing: ${to_install[*]}..."
  pnpx skills add https://github.com/mattpocock/skills $skill_flags -g -y --agent claude-code
fi

# External skills (install-only — removals handled above via pnpx list)
for entry in "${SKILLS[@]}"; do
  echo "Installing external skill: $entry"
  pnpx skills add $entry -g -y --agent claude-code
done

echo ""
echo "Done."
