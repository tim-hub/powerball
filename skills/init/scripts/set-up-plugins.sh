#!/bin/bash
# Install recommended Claude Code plugins

PLUGINS=(
  frontend-design
  pyright-lsp
  context7
  superpowers
  code-review
  github
  feature-dev
  code-simplifier
  typescript-lsp
  commit-commands
  security-guidance
  pr-review-toolkit
  ralph-loop
  playwright
  claude-md-management
  claude-code-setup
  agent-sdk-dev
  explanatory-output-style
  plugin-dev
  hookify
  skill-creator
  learning-output-style
  playground
  huggingface-skills
  firebase
)

echo ""
echo "Recommended plugins to install:"
for plugin in "${PLUGINS[@]}"; do
  echo "  - ${plugin}@claude-plugins-official"
done
echo "  - superpowers@superpowers-marketplace"
echo ""

read -r -p "Install all recommended plugins? (y/N): " answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
  for plugin in "${PLUGINS[@]}"; do
    echo "Installing $plugin..."
    claude plugin install "${plugin}@claude-plugins-official"
  done
  echo "Installing superpowers from superpowers-marketplace..."
  claude plugin install "superpowers@superpowers-marketplace"
  echo "  ✓ All plugins installed."
else
  echo "  Skipped."
fi
