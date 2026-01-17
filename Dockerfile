FROM node:24-alpine

ARG PI_VERSION='latest'

# Install agent system dependencies
RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    fd \
    git \
    ripgrep

# Install agent
RUN npm install -g @mariozechner/pi-coding-agent@${PI_VERSION}

# Create directories (app for code, .pi for agent configuration)
RUN mkdir -p /app && \
    mkdir -p /home/node/.pi && \
    chgrp -R 0 /app && \
    chgrp -R 0 /home/node && \
    chmod -R g=u /app && \
    chmod -R g=u /home/node
ENV HOME=/home/node

# Enter code directory and run agent by default
WORKDIR /app
ENTRYPOINT ["pi"]
