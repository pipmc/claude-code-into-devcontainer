#!/bin/bash
set -e

# Smoke test for claude-config-mount feature
# Verifies that host Claude config is accessible inside the container
# Note: The CI workflow creates dummy ~/.claude and ~/.claude.json on the host
#       with known content before running this test

# Test that ~/.claude exists (should be a symlink to the mounted dir)
if [ ! -e "$HOME/.claude" ]; then
    echo "FAIL: ~/.claude does not exist"
    exit 1
fi

# Test that ~/.claude.json exists (should be a symlink to the mounted file)
if [ ! -e "$HOME/.claude.json" ]; then
    echo "FAIL: ~/.claude.json does not exist"
    exit 1
fi

# Verify ~/.claude is a symlink pointing to the mount location
if [ -L "$HOME/.claude" ]; then
    target=$(readlink "$HOME/.claude")
    if [ "$target" != "/var/claude-config" ]; then
        echo "FAIL: ~/.claude symlink points to '$target' instead of /var/claude-config"
        exit 1
    fi
else
    echo "FAIL: ~/.claude is not a symlink"
    exit 1
fi

# Verify ~/.claude.json is a symlink pointing to the mount location
if [ -L "$HOME/.claude.json" ]; then
    target=$(readlink "$HOME/.claude.json")
    if [ "$target" != "/var/claude-settings.json" ]; then
        echo "FAIL: ~/.claude.json symlink points to '$target' instead of /var/claude-settings.json"
        exit 1
    fi
else
    echo "FAIL: ~/.claude.json is not a symlink"
    exit 1
fi

# Verify content from host is accessible (CI creates a test-marker file)
if [ -f "$HOME/.claude/test-marker" ]; then
    content=$(cat "$HOME/.claude/test-marker")
    if [ "$content" != "claude-config-mount-test" ]; then
        echo "FAIL: ~/.claude/test-marker has unexpected content: $content"
        exit 1
    fi
else
    echo "FAIL: ~/.claude/test-marker not found - host content not accessible"
    exit 1
fi

# Verify ~/.claude.json content
if [ -f "$HOME/.claude.json" ]; then
    content=$(cat "$HOME/.claude.json")
    if [ "$content" != '{"test": true}' ]; then
        echo "FAIL: ~/.claude.json has unexpected content: $content"
        exit 1
    fi
else
    echo "FAIL: ~/.claude.json not readable"
    exit 1
fi

echo "PASS: All tests passed!"
