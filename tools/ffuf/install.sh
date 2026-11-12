#!/bin/sh
# Vendored installer for ffuf (https://github.com/ffuf/ffuf).
# Downloads the latest release for the CURRENT platform (macOS/Linux, amd64/arm64)
# into tools/ffuf/bin/. Idempotent: re-running keeps a working install.
# Used by `tof-pentest install`, locally and inside the Docker image.
set -eu

BIN="ffuf"
ORG="ffuf"
REPO="ffuf"
EXT="tar.gz"

HERE="$(cd "$(dirname "$0")" && pwd)"
DEST="$HERE/bin"
mkdir -p "$DEST"

have_working() {
  [ -x "$DEST/$1" ] || return 1
  "$DEST/$1" --version >/dev/null 2>&1 && return 0
  "$DEST/$1" -version >/dev/null 2>&1 && return 0
  "$DEST/$1" -V >/dev/null 2>&1 && return 0
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

# Asset OS-name variants: only allow alternate spellings of the SAME OS
# (e.g. "macOS" for darwin) - a cross-OS alternation lets the wrong-OS
# asset win when it is listed first in the API response.
case "$OS" in
  darwin) OSALT="darwin|macOS" ;;
  *)      OSALT="$OS" ;;
esac

API="https://api.github.com/repos/${ORG}/${REPO}/releases/latest"
URL="$(curl -fsSL "$API" | tr ',' '\n' | grep -o 'https://[^"]*' | grep -E "${BIN}_[0-9][0-9.]*_(${OSALT})_${ARCH}\.${EXT}$" | head -n 1 || true)"
if [ -z "$URL" ]; then
  echo "[fail] no ${OS}/${ARCH} release asset for ${ORG}/${REPO}" >&2
  exit 1
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
echo "[..] downloading $URL"
curl -fL --retry 2 -o "$TMP/$BIN.pkg" "$URL"
if [ "$EXT" = "zip" ]; then
  unzip -o -q "$TMP/$BIN.pkg" -d "$TMP"
else
  tar -xzf "$TMP/$BIN.pkg" -C "$TMP"
fi
if [ -f "$TMP/$BIN" ]; then
  install -m 0755 "$TMP/$BIN" "$DEST/$BIN"
else
  FOUND="$(find "$TMP" -type f -name "$BIN" | head -n 1 || true)"
  [ -n "$FOUND" ] || { echo "[fail] binary $BIN not found in release archive" >&2; exit 1; }
  install -m 0755 "$FOUND" "$DEST/$BIN"
fi
echo "[ok] installed $BIN -> $DEST/$BIN"
"$DEST/$BIN" --version 2>&1 | head -n 1 || true
