#!/bin/bash
# Copy openspec templates to the project's openspec/ folder

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TEMPLATES_DIR="$SCRIPT_DIR/../templates"
PROJECT_DIR="${1:-$(pwd)}"
OPENSPEC_DIR="$PROJECT_DIR/openspec"

if [ ! -d "$TEMPLATES_DIR" ]; then
  echo "Error: templates directory not found at $TEMPLATES_DIR"
  exit 1
fi

# Copy openspec config and schemas
mkdir -p "$OPENSPEC_DIR"
cp -rf "$TEMPLATES_DIR/config.yaml" "$OPENSPEC_DIR/"
[ -d "$TEMPLATES_DIR/schemas" ] && cp -rf "$TEMPLATES_DIR/schemas" "$OPENSPEC_DIR/"
echo "OpenSpec initialized at $OPENSPEC_DIR"
