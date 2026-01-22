FROM node:22-alpine

ARG PI_VERSION='latest'

# Set default TERM for a better out-of-the-box experience
ENV TERM=xterm-256color
ENV HOME=/home/node
ENV GIT_CONFIG_GLOBAL=/home/node/.gitconfig

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

# Create directories (app for code, .pi for agent configuration)
RUN mkdir -p /app /home/node/.pi /home/node/.ssh && \
    chgrp -R 0 /app /home/node && \
    chmod -R g=u /app /home/node && \
    chmod 700 /home/node/.ssh

# Support SSH in rootless
RUN echo "Include /home/node/.ssh/config" >> /etc/ssh/ssh_config && \
    echo "IdentityFile /home/node/.ssh/id_rsa" >> /etc/ssh/ssh_config && \
    echo "IdentityFile /home/node/.ssh/id_ed25519" >> /etc/ssh/ssh_config && \
    echo "IdentityFile /home/node/.ssh/id_ecdsa" >> /etc/ssh/ssh_config && \
    echo "IdentityFile /home/node/.ssh/id_dsa" >> /etc/ssh/ssh_config && \
    echo "UserKnownHostsFile /home/node/.ssh/known_hosts" >> /etc/ssh/ssh_config && \
    echo "StrictHostKeyChecking accept-new" >> /etc/ssh/ssh_config

# Install agent
RUN npm install -g @mariozechner/pi-coding-agent@${PI_VERSION} && \
    npm cache clean --force

# Enter code directory and run agent by default
WORKDIR /app
ENTRYPOINT ["pi"]
