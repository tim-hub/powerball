#!/bin/bash
# Add filesystem and chrome-devtools MCP servers to ~/.claude.json if they don't exist

CLAUDE_JSON="$HOME/.claude.json"

# Ensure jq is available
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required but not installed. Install it with: brew install jq"
  exit 1
fi

# Create ~/.claude.json if it doesn't exist
if [ ! -f "$CLAUDE_JSON" ]; then
  echo '{"mcpServers":{}}' > "$CLAUDE_JSON"
  echo "Created: $CLAUDE_JSON"
fi

# Ensure mcpServers key exists
if ! jq -e '.mcpServers' "$CLAUDE_JSON" &>/dev/null; then
  jq '. + {"mcpServers":{}}' "$CLAUDE_JSON" > "$CLAUDE_JSON.tmp" && mv "$CLAUDE_JSON.tmp" "$CLAUDE_JSON"
fi

# Add filesystem server if missing
if jq -e '.mcpServers.filesystem' "$CLAUDE_JSON" &>/dev/null; then
  echo "Skipped: filesystem (already configured)"
else
  jq '.mcpServers.filesystem = {
    "type": "stdio",
    "command": "bunx",
    "args": ["-y", "@modelcontextprotocol/server-filesystem", "/tmp", "~/dev", "~/git", "~/Documents/pri/playground"],
    "env": {}
  }' "$CLAUDE_JSON" > "$CLAUDE_JSON.tmp" && mv "$CLAUDE_JSON.tmp" "$CLAUDE_JSON"
  echo "Added: filesystem"
fi

# Add chrome-devtools server if missing
if jq -e '.mcpServers."chrome-devtools"' "$CLAUDE_JSON" &>/dev/null; then
  echo "Skipped: chrome-devtools (already configured)"
else
  jq '.mcpServers."chrome-devtools" = {
    "command": "bunx",
    "args": ["-y", "chrome-devtools-mcp@latest"]
  }' "$CLAUDE_JSON" > "$CLAUDE_JSON.tmp" && mv "$CLAUDE_JSON.tmp" "$CLAUDE_JSON"
  echo "Added: chrome-devtools"
fi
