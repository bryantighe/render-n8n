# Stage 1: grab fontconfig + deps from Alpine
FROM alpine:latest AS fontstage
RUN apk add --no-cache fontconfig

# Stage 2: keep n8n on latest
FROM docker.n8n.io/n8nio/n8n:latest

USER root


# Copy fontconfig binary + config
COPY --from=fontstage /usr/bin/fc-cache /usr/bin/fc-cache
COPY --from=fontstage /etc/fonts /etc/fonts

# Copy only the libraries fc-cache needs (Alpine puts them in /usr/lib)
# This is still a set, but much safer than copying /usr/lib blindly when paths differ.
COPY --from=fontstage /usr/lib/libfontconfig.so* /usr/lib/
COPY --from=fontstage /usr/lib/libfreetype.so* /usr/lib/
COPY --from=fontstage /usr/lib/libexpat.so* /usr/lib/
COPY --from=fontstage /usr/lib/libbz2.so* /usr/lib/
COPY --from=fontstage /usr/lib/libpng16.so* /usr/lib/
COPY --from=fontstage /usr/lib/libbrotlidec.so* /usr/lib/
COPY --from=fontstage /usr/lib/libbrotlicommon.so* /usr/lib/
COPY --from=fontstage /usr/lib/libz.so* /usr/lib/

# Your fonts
RUN mkdir -p /home/node/.local/share/fonts
COPY fonts/ /home/node/.local/share/fonts/
RUN chown -R node:node /home/node/.local

# Rebuild font cache (now fc-cache exists)
RUN fc-cache -f -v

USER node
VOLUME ["/home/node/.n8n"]
