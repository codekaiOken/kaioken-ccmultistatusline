#!/bin/sh
#
# install.sh — Install Kaioken CC Multistatusline for Claude Code
#
# Copies the statusline script and configures ~/.claude/settings.json

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.claude/kaioken-status.sh"
SETTINGS="$HOME/.claude/settings.json"

echo "Installing Kaioken CC Multistatusline..."

# Ensure ~/.claude exists
mkdir -p "$HOME/.claude"

# Copy script
cp "$SCRIPT_DIR/kaioken-status.sh" "$DEST"
chmod +x "$DEST"
echo "  Copied kaioken-status.sh -> $DEST"

# Configure settings.json
if [ -f "$SETTINGS" ]; then
  # Check if statusLine already exists
  if echo "$(cat "$SETTINGS")" | jq -e '.statusLine' >/dev/null 2>&1; then
    echo ""
    echo "  ⚠️  ~/.claude/settings.json already has a statusLine config."
    echo "  To use Kaioken, manually set it to:"
    echo ""
    echo '  "statusLine": {'
    echo '    "type": "command",'
    echo "    \"command\": \"bash $DEST\""
    echo '  }'
    echo ""
  else
    # Add statusLine to existing settings
    tmp=$(mktemp)
    jq --arg cmd "bash $DEST" '. + {"statusLine": {"type": "command", "command": $cmd}}' "$SETTINGS" > "$tmp"
    mv "$tmp" "$SETTINGS"
    echo "  Updated $SETTINGS with statusLine config"
  fi
else
  # Create new settings.json
  cat > "$SETTINGS" <<EOF
{
  "statusLine": {
    "type": "command",
    "command": "bash $DEST"
  }
}
EOF
  echo "  Created $SETTINGS"
fi

echo ""
echo "  ✅ Kaioken CC Multistatusline installed!"
echo "  Restart Claude Code to see it in action."
