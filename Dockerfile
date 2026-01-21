# Base image
FROM n8nio/n8n:latest

# Switch to root to install system dependencies
USER root

# Install FFmpeg (and optionally Python + tools for audio manipulation)
# RUN apk update && \
#    apk add --no-cache \
#      ffmpeg \
#      # Optional: uncomment if you need Python support
#      # python3 py3-pip build-base python3-dev \
#    && rm -rf /var/cache/apk/*

# Create fonts directory for node user
RUN mkdir -p /home/node/.local/share/fonts

# Copy fonts from repo into container
COPY fonts/ /home/node/.local/share/fonts/

# Fix ownership
RUN chown -R node:node /home/node/.local

# Rebuild font cache
RUN fc-cache -f -v

# (Optional) If using Python for audio or data processing:
# RUN python3 -m ensurepip && \
#     pip3 install --no-cache-dir numpy librosa

# Switch back to default user
USER node

# Persist data directory
VOLUME ["/home/node/.n8n"]
