#!/bin/bash
set -e

# Installation script for claude-dev

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"

echo "Installing claude-dev..."

# Create install directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Create a wrapper script that points to the actual location
cat > "$INSTALL_DIR/claude-dev" << EOF
#!/bin/bash
exec "$SCRIPT_DIR/bin/claude-dev" "\$@"
EOF

chmod +x "$INSTALL_DIR/claude-dev"

echo "Installed claude-dev to $INSTALL_DIR/claude-dev"

# Check if install dir is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "Note: $INSTALL_DIR is not in your PATH"
    echo "Add it by running:"
    echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
    echo ""
    echo "Or add this line to your shell profile (~/.bashrc, ~/.zshrc, etc.)"
fi

echo ""
echo "Usage:"
echo "  cd /path/to/repo-with-devcontainer"
echo "  claude-dev"
