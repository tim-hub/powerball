#!/bin/bash
# Disable OpenSpec telemetry by ensuring OPENSPEC_TELEMETRY=0 is set in ~/.zshrc

ZSHRC="$HOME/.zshrc"
EXPORT_LINE='export OPENSPEC_TELEMETRY=0'

if grep -qF "$EXPORT_LINE" "$ZSHRC" 2>/dev/null; then
  echo "OPENSPEC_TELEMETRY=0 already set in $ZSHRC"
else
  echo "" >> "$ZSHRC"
  echo "$EXPORT_LINE" >> "$ZSHRC"
  echo "Added OPENSPEC_TELEMETRY=0 to $ZSHRC"
fi
