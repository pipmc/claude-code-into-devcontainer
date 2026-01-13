#!/bin/bash
set -eo pipefail

CCIND_HOME="${CCIND_HOME:-$HOME/.ccind}"

# If already installed, update via git pull
if [ -d "$CCIND_HOME" ] && [ -d "$CCIND_HOME/.git" ]; then
    echo "Updating ccind..."
    git -C "$CCIND_HOME" pull
    echo "Update complete."
    exit 0
fi

# Fresh install
echo "Installing ccind to $CCIND_HOME..."

git clone https://github.com/pipmc/claude-code-into-devcontainer.git "$CCIND_HOME"

# Add to shell rc files
for rc_file in ~/.bashrc ~/.zshrc; do
    if [ -f "$rc_file" ]; then
        echo "export CCIND_HOME=\"$CCIND_HOME\"" >> "$rc_file"
        echo 'export PATH="${PATH}:${CCIND_HOME}/bin"' >> "$rc_file"
        echo "Added ccind to $rc_file"
    fi
done

echo ""
echo "Installation complete. Please restart your terminal or run:"
echo "  source ~/.bashrc  # or ~/.zshrc"
echo ""
echo "Then run 'ccind --help' to get started."
