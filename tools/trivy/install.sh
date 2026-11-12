#!/bin/sh
# Vendored installer for trivy (https://github.com/aquasecurity/trivy).
# Downloads the latest release for the CURRENT platform (macOS/Linux, amd64/arm64)
# into tools/trivy/bin/. Idempotent: re-running keeps a working install.
# Used by tof-pentest install, locally and inside the Docker image.
set -eu

BIN="trivy"
ORG="aquasecurity"
REPO="trivy"

HERE="$(cd "$(dirname "$0")" && pwd)"
DEST="$HERE/bin"
mkdir -p "$DEST"

have_working() {
  [ -x "$DEST/$1" ] || return 1
  "$DEST/$1" --version >/dev/null 2>&1 && return 0
  "$DEST/$1" version >/dev/null 2>&1 && return 0
  "$DEST/$1" -h >/dev/null 2>&1
}

if have_working "$BIN"; then
  echo "[ok] $BIN already installed ($DEST/$BIN) - skipping download"
  exit 0
fi

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$(uname -m)" in
  x86_64|amd64)  ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "[fail] unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac
# trivy release asset naming: trivy_<ver>_<OS>-<variant>.tar.gz
case "$OS-$ARCH" in
  darwin-amd64) SUFFIX="macOS-64bit" ;;
  darwin-arm64) SUFFIX="macOS-ARM64" ;;
  linux-amd64)  SUFFIX="Linux-64bit" ;;
  linux-arm64)  SUFFIX="Linux-ARM64" ;;
  *) echo "[fail] unsupported platform: $OS/$ARCH" >&2; exit 1 ;;
esac


API="https://api.github.com/repos/${ORG}/${REPO}/releases/latest"
URL="$(curl -fsSL "$API" | tr ',' '\n' | grep -o 'https://[^"]*' | grep -E "${BIN}_[0-9][0-9.]*_${SUFFIX}\.tar\.gz$" | head -n 1 || true)"
if [ -z "$URL" ]; then
  echo "[fail] no ${OS}/${ARCH} release asset for ${ORG}/${REPO}" >&2
  exit 1
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
echo "[..] downloading $URL"
curl -fL --retry 2 -o "$TMP/$BIN.pkg" "$URL"
tar -xzf "$TMP/$BIN.pkg" -C "$TMP"
if [ -f "$TMP/$BIN" ]; then
  install -m 0755 "$TMP/$BIN" "$DEST/$BIN"
else
  FOUND="$(find "$TMP" -type f -name "$BIN" | head -n 1 || true)"
  [ -n "$FOUND" ] || { echo "[fail] binary $BIN not found in release archive" >&2; exit 1; }
  install -m 0755 "$FOUND" "$DEST/$BIN"
fi
echo "[ok] installed $BIN -> $DEST/$BIN"
"$DEST/$BIN" --version 2>&1 | head -n 1 || true
