#!/bin/bash
# Install recommended Claude Code plugins

PLUGINS=(
  agent-sdk-dev
  claude-code-setup
  claude-md-management
  code-review
  code-simplifier
  commit-commands
  context7
  explanatory-output-style
  feature-dev
  frontend-design
  gopls-lsp
  hookify
  huggingface-skills
  learning-output-style
  playwright
  playground
  plugin-dev
  powerball
  pr-review-toolkit
  pyright-lsp
  ralph-loop
  security-guidance
  skill-creator
  superpowers
  typescript-lsp
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
