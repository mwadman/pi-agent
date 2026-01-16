FROM node:24-alpine

# Install agent system dependencies
RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    fd \
    git \
    ripgrep

# Install agent
RUN npm install -g @mariozechner/pi-coding-agent

# Create directories (app for code, .pi for agent configuration)
RUN mkdir -p /app && chown -R node:node /app
RUN mkdir -p /home/node/.pi && chown -R node:node /home/node

# Use non-root 'node' user
USER node

# Enter code directory and run agent
WORKDIR /app
ENTRYPOINT ["pi"]
