# Pi Agent Container

## Image Builds

### Automated Builds

A Github action is defined in `.github/workflows/publish.yml` to build a new image and push this to Dockerhub.  
This is triggered by a workflow in pipedream.com, which makes an POST request whenever a new version of the "@mariozechner/pi-coding-agent" npm package is available.

This workflow:

1. Checks if the relevant image version already exists on Docker Hub.
2. If an image doesn't exist for the latest version, automatically builds and pushes it with both the version tag and `latest`.

### Manual build and push

```bash
docker build -t michaelwadman/pi-agent:0.49.2 --build-arg PI_VERSION='0.49.2' .
docker tag michaelwadman/pi-agent:0.49.2 michaelwadman/pi-agent:latest
docker push michaelwadman/pi-agent:0.49.2
docker push michaelwadman/pi-agent:latest
```

## Setup and Use

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
- **SSH Support**: If your git repositories use SSH, you may need to mount your SSH keys and/or agent socket to allow the container to authenticate with `-v "$HOME/.ssh:/home/node/.ssh"` and/or `-v "$SSH_AUTH_SOCK:/run/host-services/ssh-auth.sock" -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock`. \
  In the Dockerfile, `/etc/ssh/ssh_config` is configured to use absolute paths in `/home/node/.ssh` as this ensures compatibility with rootless Docker and OpenShift (which use random UIDs). Because these environments often lack a valid entry in `/etc/passwd` for the running user, the SSH client cannot automatically resolve the `~` (home) directory regardless of the UID or the `$HOME` environment variable.
- **Local Model Hosting**: To connect to a model provided from the same host machine you will need to configure Pi to point at the Docker network gateway, or add a host entry at runtime. \
  For example, to connect to Ollama running on the default Docker bridge IP, you would use `http://172.17.0.1:11434/v1` as your baseUrl. Or you could add `--add-host "host.docker.internal:host-gateway"` to the run command and use `http://host.docker.internal:11434/v1` as your baseUrl. \
  In rootless docker environments, you may need to replace the Docker bridge IP/host-gateway with the LAN IP of your host (e.g. `--add-host "host.docker.internal:$(ip route get 1 | grep -Po 'src \K[\d.]+')"`). This is because the "slirp4netns" network stack prohibits connections to the host via the loopback/gateway interfaces. \
  If using Ollama, remember to set the `OLLAMA_HOST` configuration appropriately to allow connections from the Docker network.
