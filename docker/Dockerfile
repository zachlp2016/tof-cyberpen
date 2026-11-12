FROM node:22-bookworm-slim

# TOF-AI-Pentester gunship image (repo: TOF-Penetration-Testing).
# All 10 vendored tools are installed for the container platform at build time
# (tools/<tool>/install.sh) and every tool is visible on PATH inside the image.
#
# Build order matters for layer caching: the tools are vendored from the
# minimal stable inputs (tof-pentest/ + tools/ installers) BEFORE the rest of
# the repo is copied, so routine repo edits (docs, wiki, runs, projects, ...)
# do not invalidate the expensive tool-download layer.

RUN apt-get update && apt-get install -y --no-install-recommends \
        bsdmainutils ca-certificates curl git procps unzip python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Minimal stable inputs for vendoring (.dockerignore trims runs/, tools/*/bin, ...)
COPY tof-pentest/ tof-pentest/
COPY tools/ tools/

# vendor all tools for this platform (linux amd64/arm64):
#  - nmap: apt package + launcher  - sqlmap/testssl.sh: source clone + launcher
#  - naabu/nuclei/httpx/katana/ffuf: latest GitHub release binaries
RUN node tof-pentest/bin/tof-pentest.js install

# Copy the rest of the repo on top. This merges (does not delete) and the
# dockerignore keeps tools/*/bin + tools/*/source out of the context, so the
# vendored artifacts from the cached layer above are preserved.
COPY . .

# make the command line visible: every tool + the gunship itself on PATH
RUN sh -c 'for b in /app/tools/*/bin/*; do [ -f "$b" ] || continue; ln -sf "$b" "/usr/local/bin/$(basename "$b")"; done' \
    && chmod +x /app/tof-pentest/bin/tof-pentest.js \
    && ln -sf /app/tof-pentest/bin/tof-pentest.js /usr/local/bin/tof-pentest

ENTRYPOINT ["tof-pentest"]
CMD ["help"]
