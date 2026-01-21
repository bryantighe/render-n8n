# Base image (official registry)
FROM docker.n8n.io/n8nio/n8n:latest

# Switch to root to install system dependencies
USER root

# Install ffmpeg + fontconfig (fc-cache comes from fontconfig)
RUN apt-get update \
  && apt-get install -y --no-install-recommends ffmpeg fontconfig \
  && rm -rf /var/lib/apt/lists/*

# Create fonts directory for node user
RUN mkdir -p /home/node/.local/share/fonts

# Copy fonts from repo into container
COPY fonts/ /home/node/.local/share/fonts/

# Fix ownership
RUN chown -R node:node /home/node/.local

# Rebuild font cache
RUN fc-cache -f -v

# Switch back to default user
USER node

# Persist data directory
VOLUME ["/home/node/.n8n"]
