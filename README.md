# Pi Agent Container

## Build and push

```bash
docker build -t michaelwadman/pi-agent:0.49.2 --build-arg PI_VERSION='0.49.2' .
docker tag michaelwadman/pi-agent:0.49.2 michaelwadman/pi-agent:latest
docker push michaelwadman/pi-agent:0.49.2
docker push michaelwadman/pi-agent:latest
```

### Automated Builds

The Github action defined in `.github/workflows/publish.yml`:

1. Checks for the latest version of `@mariozechner/pi-coding-agent` on npm every 6 hours.
2. Checks if the relevant image version already exists on Docker Hub.
3. If an image doesn't exist for the latest version, automatically builds and pushes it with both the version tag and `latest`.

## Setup

### Local configuration directory

The Pi agent uses the directory ~/.pi to store it's configuration.  
If this directory doesn't already exist on your local machine, create this with `mkdir ~/.pi`.

### API keys

API keys can either be specified in an authfile (recommended) or via environment variables.  
See [API Keys and OAuth](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent#api-keys--oauth) in the pi-agent README.

## Running

```bash
docker run -it --rm --name pi-agent \
  --init \
  -e TERM=$TERM \
  -v "$(pwd):/app" \
  -v "$HOME/.pi:/home/node/.pi" \
  -v "$HOME/.gitconfig:/home/node/.gitconfig" \
  michaelwadman/pi-agent:latest
```

### Notes

- **Git Identity**: Mounting `.gitconfig` allows the agent to make commits using your git identity. If you use a credential manager on your host, you may still need to provide credentials manually or via environment variables inside the container.
- **API Authentication**: If using environment variables for API authentication, add them to the run command (e.g., `-e ANTHROPIC_API_KEY="your_api_key_here"`).
- **OAuth Login**: If you want to use the `/login` command to authenticate to services with OAuth, you will need to set host networking mode with `--network host`.
- **SSH Support**: If your git repositories use SSH, you may need to mount your SSH agent socket to allow the container to authenticate with `-v "$SSH_AUTH_SOCK:/run/host-services/ssh-auth.sock" -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock`.
