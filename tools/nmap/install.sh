#!/bin/sh
# Vendored installer for nmap (https://github.com/nmap/nmap).
# nmap is a system package (brew/apt); this ensures it exists, then installs a
# launcher at tools/nmap/bin/nmap that execs the system binary, so the tool
# lives in its own folder per the repo layout.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
DEST="$HERE/bin"
mkdir -p "$DEST"

if command -v nmap >/dev/null 2>&1; then
  SYS="$(command -v nmap)"
else
  if command -v brew >/dev/null 2>&1; then
    echo "[..] brew install nmap"
    brew install nmap
  elif command -v apt-get >/dev/null 2>&1; then
    echo "[..] apt-get install nmap"
    if [ "$(id -u)" = "0" ]; then SUDO=""; else SUDO="sudo"; fi
    $SUDO apt-get update -y && $SUDO apt-get install -y --no-install-recommends nmap
  else
    echo "[fail] need brew or apt-get to install nmap" >&2
    exit 1
  fi
  SYS="$(command -v nmap)"
fi

printf '#!/bin/sh\nexec "%s" "$@"\n' "$SYS" > "$DEST/nmap"
chmod +x "$DEST/nmap"
echo "[ok] nmap ready: $DEST/nmap -> $SYS"
"$DEST/nmap" -V 2>/dev/null | head -n 1 || true
