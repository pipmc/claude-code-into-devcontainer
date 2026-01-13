#!/bin/bash
set -e

# Install a script that will create symlinks at container start time
# This is needed because the home directory may have a volume mounted over it,
# which would hide symlinks created during image build.

cat > /usr/local/bin/setup-claude-config-symlinks << 'SCRIPT'
#!/bin/bash
set -e

# Get the current user's home directory
USER_HOME="$HOME"

echo "Setting up Claude config symlinks in $USER_HOME"

create_symlink() {
    local target="$1"
    local link="$2"

    # If correct symlink exists, skip
    if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
        echo "Symlink $link already correct, skipping"
        return
    fi

    # Remove any existing path (file, directory, or wrong symlink)
    if [ -e "$link" ] || [ -L "$link" ]; then
        echo "Removing existing $link to create symlink"
        rm -rf "$link"
    fi

    ln -s "$target" "$link"
    echo "Created symlink: $link -> $target"
}

create_symlink "/var/claude-config" "$USER_HOME/.claude"
create_symlink "/var/claude-settings.json" "$USER_HOME/.claude.json"

echo "Claude config symlinks setup complete"
SCRIPT

chmod +x /usr/local/bin/setup-claude-config-symlinks

echo "Installed /usr/local/bin/setup-claude-config-symlinks"
echo "This will be run via postCreateCommand to set up symlinks after volumes are mounted."
