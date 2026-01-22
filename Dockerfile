FROM node:22-alpine

ARG PI_VERSION='latest'

# Set default TERM for a better out-of-the-box experience
ENV TERM=xterm-256color

# Install agent system dependencies
RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    fd \
    file \
    git \
    jq \
    openssh-client \
    ripgrep

# Install agent
RUN npm install -g @mariozechner/pi-coding-agent@${PI_VERSION} && \
    npm cache clean --force

# Create directories (app for code, .pi for agent configuration)
RUN mkdir -p /app /home/node/.pi && \
    chgrp -R 0 /app /home/node && \
    chmod -R g=u /app /home/node

ENV HOME=/home/node

# Enter code directory and run agent by default
WORKDIR /app
ENTRYPOINT ["pi"]
