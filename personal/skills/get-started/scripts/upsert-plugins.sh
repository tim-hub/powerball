#!/bin/bash
# Install recommended Claude Code plugins

PLUGINS=(
    # use at project level
  # agent-sdk-dev
  # playground
  # plugin-dev
  # huggingface-skills
  # hookify
  # frontend-design
  claude-code-setup
  claude-md-management
  code-review
  code-simplifier
  # commit-commands # too simple
  explanatory-output-style
  feature-dev
  gopls-lsp
  learning-output-style
  pr-review-toolkit
  pyright-lsp
  ralph-loop
  security-guidance
  skill-creator
  typescript-lsp
)

echo ""
echo "Recommended plugins to install:"
for plugin in "${PLUGINS[@]}"; do
  echo "  - ${plugin}@claude-plugins-official"
done
echo "  - spower@spower"
echo ""

read -r -p "Install all recommended plugins? (y/N): " answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
  for plugin in "${PLUGINS[@]}"; do
    echo "Installing $plugin..."
    claude plugin install "${plugin}@claude-plugins-official"
  done

  echo "Adding spower marketplace..."
  claude plugin marketplace add tim-hub/superpowers
  echo "Installing spower..."
  claude plugin install spower@spower
else
  echo "  Skipped."
fi
