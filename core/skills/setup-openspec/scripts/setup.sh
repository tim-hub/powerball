#!/bin/bash
# Copy openspec templates to the project's openspec/ folder

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TEMPLATES_DIR="$SCRIPT_DIR/../templates"
PROJECT_DIR="${1:-$(pwd)}"
TARGET_DIR="$PROJECT_DIR/openspec"

if [ ! -d "$TEMPLATES_DIR" ]; then
  echo "Error: templates directory not found at $TEMPLATES_DIR"
  exit 1
fi

mkdir -p "$TARGET_DIR"
cp -rf "$TEMPLATES_DIR/." "$TARGET_DIR/"
echo "OpenSpec initialized at $TARGET_DIR"
