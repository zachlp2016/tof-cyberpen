#!/bin/sh
# Vendored installer for testssl.sh (https://github.com/testssl/testssl.sh).
# Clones the source into tools/testssl.sh/source and installs a launcher at
# tools/testssl.sh/bin/testssl.sh that execs it with bash.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/source"
DEST="$HERE/bin"
mkdir -p "$DEST"

if [ ! -f "$SRC/testssl.sh" ]; then
  echo "[..] cloning https://github.com/testssl/testssl.sh -> $SRC"
  rm -rf "$SRC"
  git clone --depth 1 https://github.com/testssl/testssl.sh "$SRC"
fi

printf '#!/bin/sh\nexec bash "%s/testssl.sh" "$@"\n' "$SRC" > "$DEST/testssl.sh"
chmod +x "$DEST/testssl.sh"
echo "[ok] testssl.sh ready: $DEST/testssl.sh"
