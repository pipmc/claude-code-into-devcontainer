# ccind - Claude Code in Devcontainer

Run Claude Code CLI inside your project's devcontainer with your host configuration automatically mounted.

## What it does

`ccind` launches Claude Code inside a repository's devcontainer, automatically:
- Installing the [Claude Code CLI](https://github.com/anthropics/claude-code) in the container
- Mounting your host's `~/.claude` directory and `~/.claude.json` settings
- Creating symlinks so Claude finds your authentication and configuration

## Installation

```bash
curl -fLsS https://raw.githubusercontent.com/pipmc/claude-code-into-devcontainer/main/install.sh | bash
```

## Prerequisites

- [devcontainer CLI](https://github.com/devcontainers/cli): `npm install -g @devcontainers/cli`
- Docker
- A project with a `.devcontainer` directory

## Usage

```bash
# Run in current directory
ccind

# Run in a specific project
ccind /path/to/project
```

The first run may take a while as it builds the devcontainer and installs Claude Code.

## Development

### Testing locally

Run the devcontainer feature tests:

```bash
devcontainer features test -f claude-config-mount .
```

### Publishing to a local registry

1. Start a local Docker registry:
   ```bash
   docker run -d -p 5000:5000 registry:2
   ```

2. Publish the feature:
   ```bash
   ./scripts/dev-publish.sh
   # Or specify a custom registry:
   ./scripts/dev-publish.sh my-registry.example.com:5000
   ```

3. Test with the published feature:
   ```bash
   CCIND_CONFIG_MOUNT_FEATURE=localhost:5000/claude-config-mount:latest ccind
   ```

### Environment variables

| Variable | Description |
|----------|-------------|
| `CCIND_CONFIG_MOUNT_FEATURE` | Use a published feature instead of local copy (e.g., `localhost:5000/claude-config-mount:latest`) |
