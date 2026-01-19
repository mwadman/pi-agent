# Pi Agent Container

## Build

```bash
# Build a specific version
docker build -t michaelwadman/pi-agent:0.49.0 --build-arg PI_VERSION='0.49.0' .
# Build the latest version
docker build -t michaelwadman/pi-agent:latest --build-arg PI_VERSION='latest' .
```

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
  michaelwadman/pi-agent:latest
```

If using environment variables for API authentication, add this to the run command too (e.g. `-e ANTHROPIC_API_KEY="your_api_key_here"`).  
If you want to use the `/login` command to authenticate to services with OAuth, you will need to set host networking mode with `--network host`
