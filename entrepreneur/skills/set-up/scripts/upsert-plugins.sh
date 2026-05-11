#!/bin/bash
# Install entrepreneur-focused plugins

INFERENCE_SH_PLUGINS=(
  inference-sh
)

POSTHOG_PLUGINS=(
  posthog
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
echo "Entrepreneur plugins to install:"
echo ""
echo "inference-sh plugins (from inference-sh/skills marketplace):"
for plugin in "${INFERENCE_SH_PLUGINS[@]}"; do
  echo "  - ${plugin}@inference-sh"
done
echo ""
echo "PostHog analytics:"
for plugin in "${POSTHOG_PLUGINS[@]}"; do
  echo "  - ${plugin}"
done
echo ""
echo "PM plugins (from phuryn/pm-skills marketplace):"
for plugin in "${PM_PLUGINS[@]}"; do
  echo "  - ${plugin}@pm-skills"
done
echo ""

read -r -p "Install all entrepreneur plugins? (y/N): " answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
  echo "Adding inference-sh marketplace..."
  claude plugin marketplace add inference-sh/skills

  for plugin in "${INFERENCE_SH_PLUGINS[@]}"; do
    echo "Installing $plugin..."
    claude plugin install "${plugin}@inference-sh"
  done

  for plugin in "${POSTHOG_PLUGINS[@]}"; do
    echo "Installing $plugin..."
    claude plugin install "${plugin}"
  done

  echo "Adding pm-skills marketplace..."
  claude plugin marketplace add phuryn/pm-skills

  for plugin in "${PM_PLUGINS[@]}"; do
    echo "Installing $plugin..."
    claude plugin install "${plugin}@pm-skills"
  done

  echo ""
  echo "Done! Entrepreneur plugins installed."
else
  echo "  Skipped."
fi
