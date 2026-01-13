#!/bin/bash
set -e

# Get the remote user (set by devcontainer)
REMOTE_USER="${_REMOTE_USER:-root}"

# Get the user's home directory via tilde expansion
USER_HOME=$(eval echo ~"$REMOTE_USER")

echo "Setting up Claude config mount for user: $REMOTE_USER (home: $USER_HOME)"

# Check if the mount point exists
if [ ! -d "/var/claude-config" ]; then
    echo "Warning: /var/claude-config does not exist. The mount may not be available yet."
    echo "The symlink will be created anyway and should work once the container starts."
fi

# Create the symlink if it doesn't already exist
if [ -L "$USER_HOME/.claude" ]; then
    echo "Symlink $USER_HOME/.claude already exists, skipping"
elif [ -d "$USER_HOME/.claude" ]; then
    echo "Error: $USER_HOME/.claude already exists as a directory"
    exit 1
elif [ -f "$USER_HOME/.claude" ]; then
    echo "Error: $USER_HOME/.claude already exists as a file"
    exit 1
else
    ln -s /var/claude-config "$USER_HOME/.claude"
    echo "Created symlink: $USER_HOME/.claude -> /var/claude-config"
fi

# Set up the settings file symlink
if [ ! -f "/var/claude-settings.json" ]; then
    echo "Warning: /var/claude-settings.json does not exist. The mount may not be available yet."
    echo "The symlink will be created anyway and should work once the container starts."
fi

if [ -L "$USER_HOME/.claude.json" ]; then
    echo "Symlink $USER_HOME/.claude.json already exists, skipping"
elif [ -d "$USER_HOME/.claude.json" ]; then
    echo "Error: $USER_HOME/.claude.json already exists as a directory"
    exit 1
elif [ -f "$USER_HOME/.claude.json" ]; then
    echo "Error: $USER_HOME/.claude.json already exists as a file"
    exit 1
else
    ln -s /var/claude-settings.json "$USER_HOME/.claude.json"
    echo "Created symlink: $USER_HOME/.claude.json -> /var/claude-settings.json"
fi

echo "Claude config mount setup complete"
