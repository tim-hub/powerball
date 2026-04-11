#!/bin/bash
# Install recommended Claude Code plugins

PLUGINS=(
  agent-sdk-dev
  claude-code-setup
  claude-md-management
  code-review
  code-simplifier
  commit-commands
  explanatory-output-style
  feature-dev
  frontend-design
  gopls-lsp
  hookify
  huggingface-skills
  learning-output-style
  playground
  plugin-dev
  pr-review-toolkit
  pyright-lsp
  ralph-loop
  security-guidance
  skill-creator
  typescript-lsp
)

PM_PLUGINS=(
  pm-toolkit
  pm-product-strategy
  pm-product-discovery
  pm-market-research
  pm-data-analytics
  pm-marketing-growth
  pm-go-to-market
  pm-execution
)

echo ""
echo "Recommended plugins to install:"
for plugin in "${PLUGINS[@]}"; do
  echo "  - ${plugin}@claude-plugins-official"
done
echo "  - spower@spower-marketplace"
echo ""
echo "PM plugins (from phuryn/pm-skills marketplace):"
for plugin in "${PM_PLUGINS[@]}"; do
  echo "  - ${plugin}@pm-skills"
done
echo ""

read -r -p "Install all recommended plugins? (y/N): " answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
  for plugin in "${PLUGINS[@]}"; do
    echo "Installing $plugin..."
    claude plugin install "${plugin}@claude-plugins-official"
  done

  echo "Installing spower..."
  claude plugin install "spower@spower-marketplace"

  echo "Adding pm-skills marketplace..."
  claude plugin marketplace add phuryn/pm-skills

  for plugin in "${PM_PLUGINS[@]}"; do
    echo "Installing $plugin..."
    claude plugin install "${plugin}@pm-skills"
  done
else
  echo "  Skipped."
fi
