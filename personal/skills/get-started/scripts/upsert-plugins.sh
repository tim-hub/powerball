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

KARPATHY_PLUGINS=(
  andrej-karpathy-skills
)

echo ""
echo "Recommended plugins to install:"
for plugin in "${PLUGINS[@]}"; do
  echo "  - ${plugin}@claude-plugins-official"
done
echo "  - spower@spower"
echo ""
echo "Karpathy plugins (from forrestchang/andrej-karpathy-skills marketplace):"
for plugin in "${KARPATHY_PLUGINS[@]}"; do
  echo "  - ${plugin}@karpathy-skills"
done
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

  echo "Adding karpathy-skills marketplace..."
  claude plugin marketplace add forrestchang/andrej-karpathy-skills

  for plugin in "${KARPATHY_PLUGINS[@]}"; do
    echo "Installing $plugin..."
    claude plugin install "${plugin}@karpathy-skills"
  done
else
  echo "  Skipped."
fi
