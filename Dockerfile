FROM docker.n8n.io/n8nio/n8n:latest

USER root

# Install Chromium + fonts + fontconfig (Debian/Ubuntu-based)
RUN apt-get update && apt-get install -y --no-install-recommends \
  chromium \
  ca-certificates \
  fontconfig \
  fonts-noto \
  fonts-noto-cjk \
  fonts-noto-color-emoji \
  libnss3 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libgtk-3-0 \
  libcups2 \
  libdrm2 \
  libgbm1 \
  libx11-xcb1 \
  libxcomposite1 \
  libxdamage1 \
  libxrandr2 \
  libxss1 \
  libxtst6 \
  libasound2 \
  xdg-utils \
  && rm -rf /var/lib/apt/lists/*

# Your fonts
RUN mkdir -p /home/node/.local/share/fonts
COPY fonts/ /home/node/.local/share/fonts/
RUN chown -R node:node /home/node/.local

# Install the n8n Puppeteer community node
RUN mkdir -p /home/node/.n8n/nodes \
  && cd /home/node/.n8n/nodes \
  && npm install n8n-nodes-puppeteer \
  && chown -R node:node /home/node/.n8n

# Rebuild font cache
RUN fc-cache -f -v

# Help Puppeteer find Chromium (path may vary; see note below)
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

USER node
VOLUME ["/home/node/.n8n"]
