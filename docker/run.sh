#!/bin/sh
# Run the gunship inside the container. The host's runs/ dir is mounted at /app/runs
# so reports (report.md / report.json / raw outputs) land on the host.
#
# usage: docker/run.sh scan --ip 192.168.10.500 --port 8000 --type basic
#        docker/run.sh mcp            # MCP stdio server through docker
#
# Targeting the host machine from inside (macOS/Windows docker): use
# --ip host.docker.internal. On Linux, plain IPs / --net host also work.
set -eu
cd "$(dirname "$0")/.."
mkdir -p runs
exec docker run --rm -v "$PWD/runs:/app/runs" tof-ai-pentester "$@"
