#!/bin/bash
# Sync Claude Code plugins to the desired state (user scope).
# Installs missing plugins and removes unlisted ones.

# Plugins from claude-plugins-official
PLUGINS=(
    # use at project level
  # agent-sdk-dev
  # playground
  # plugin-dev
  # huggingface-skills
  # hookify
  # frontend-design
  # claude-code-setup
  chrome-devtools-mcp
  claude-md-management
  code-review
  code-simplifier
  # commit-commands # too simple
  explanatory-output-style
  feature-dev
  gopls-lsp
  # learning-output-style
  pr-review-toolkit
  pyright-lsp
  ralph-loop
  security-guidance
  skill-creator
  typescript-lsp
)

# Plugins from non-official marketplaces: "plugin-name@marketplace-id"
MARKETPLACE_PLUGINS=(
  "codex@openai-codex"                        # github: openai/codex-plugin-cc
  "harness@powerball-harness-marketplace"               # github: tim-hub/powerball-harness
  "powerball-personal@powerball-marketplace"            # github: tim-hub/powerball
  "improvement@powerball-marketplace"                   # github: tim-hub/powerball
  "entrepreneur@powerball-marketplace"                  # github: tim-hub/powerball
  "superpowers-extended-cc@spower"                      # github: tim-hub/superpowers
)

# Build allowlist from both arrays
ALLOWED=("${PLUGINS[@]}")
for entry in "${MARKETPLACE_PLUGINS[@]}"; do
  ALLOWED+=("${entry%%@*}")
done

# Get user-scope installed plugin names
installed=$(claude plugin list 2>/dev/null | awk '/❯/{name=$2; gsub(/@.*/, "", name)} /Scope: user/{print name}')

to_remove=()
to_install_official=()
to_install_marketplace=()

while IFS= read -r name; do
  [[ -z "$name" ]] && continue
  if ! printf '%s\n' "${ALLOWED[@]}" | grep -qx "$name"; then
    to_remove+=("$name")
  fi
done <<< "$installed"

for plugin in "${PLUGINS[@]}"; do
  if ! echo "$installed" | grep -qx "$plugin"; then
    to_install_official+=("$plugin")
  fi
done

for entry in "${MARKETPLACE_PLUGINS[@]}"; do
  name="${entry%%@*}"
  if ! echo "$installed" | grep -qx "$name"; then
    to_install_marketplace+=("$entry")
  fi
done

if [[ ${#to_remove[@]} -eq 0 && ${#to_install_official[@]} -eq 0 && ${#to_install_marketplace[@]} -eq 0 ]]; then
  echo "✔ Plugins already in sync."
  exit 0
fi

echo ""
for p in "${to_remove[@]}";             do echo "  - remove:  $p"; done
for p in "${to_install_official[@]}";   do echo "  + install: $p"; done
for p in "${to_install_marketplace[@]}"; do echo "  + install: $p"; done
echo ""

read -r -p "Apply changes? (y/N): " answer
[[ "$answer" != "y" && "$answer" != "Y" ]] && { echo "Skipped."; exit 0; }

for plugin in "${to_remove[@]}"; do
  echo "Removing $plugin..."
  claude plugin uninstall "$plugin"
done

for plugin in "${to_install_official[@]}"; do
  echo "Installing $plugin..."
  claude plugin install "${plugin}@claude-plugins-official"
done

if [[ ${#to_install_marketplace[@]} -gt 0 ]]; then
  # Ensure marketplaces are configured
  claude plugin marketplace add openai/codex-plugin-cc 2>/dev/null || true
  claude plugin marketplace add tim-hub/powerball-harness 2>/dev/null || true
  claude plugin marketplace add tim-hub/powerball 2>/dev/null || true
  claude plugin marketplace add tim-hub/superpowers 2>/dev/null || true

  for entry in "${to_install_marketplace[@]}"; do
    echo "Installing $entry..."
    claude plugin install "$entry"
  done
fi

echo ""
echo "Done."
