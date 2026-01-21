# Stage 1: build a minimal layer that contains fontconfig tools + libs
FROM alpine:latest AS fontstage

RUN apk add --no-cache fontconfig \
  && mkdir -p /home/node/.local/share/fonts

# Stage 2: final image stays on n8n latest
FROM docker.n8n.io/n8nio/n8n:latest

USER root

# Copy fontconfig binaries and libs into the n8n image
COPY --from=fontstage /usr/bin/fc-cache /usr/bin/fc-cache
COPY --from=fontstage /etc/fonts /etc/fonts
COPY --from=fontstage /usr/share/fonts /usr/share/fonts
COPY --from=fontstage /usr/lib /usr/lib

# Create fonts directory for node user
RUN mkdir -p /home/node/.local/share/fonts

# Copy your custom fonts from repo into container
COPY fonts/ /home/node/.local/share/fonts/

# Fix ownership
RUN chown -R node:node /home/node/.local

# Rebuild font cache (now available because we copied fc-cache + deps)
RUN fc-cache -f -v

USER node

# Persist data directory
VOLUME ["/home/node/.n8n"]
