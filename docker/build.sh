#!/bin/sh
# Build the tof-ai-pentester image and print the in-image tool table.
set -eu
cd "$(dirname "$0")/.."
docker build -f docker/Dockerfile -t tof-ai-pentester .
echo
echo 'in-image tool status:'
docker run --rm tof-ai-pentester tools
