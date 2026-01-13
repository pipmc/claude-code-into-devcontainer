#!/bin/bash
set -euo pipefail

# Publish feature to a local or custom registry
# Usage: ./scripts/dev-publish.sh [registry]
# Default registry: localhost:5000

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/.."

REGISTRY="${1:-localhost:5000}"

echo "Publishing features to $REGISTRY..."
devcontainer features publish --registry "$REGISTRY" "$REPO_ROOT/src"

echo ""
echo "Done! Test with:"
echo "  CCIND_CONFIG_MOUNT_FEATURE=$REGISTRY/claude-config-mount:latest ccind"
