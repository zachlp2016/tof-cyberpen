#!/bin/sh
# Vendored installer for sqlmap (https://github.com/sqlmapproject/sqlmap).
# Clones the source into tools/sqlmap/source and installs a launcher at
# tools/sqlmap/bin/sqlmap that execs it with python3.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/source"
DEST="$HERE/bin"
mkdir -p "$DEST"

if [ ! -f "$SRC/sqlmap.py" ]; then
  echo "[..] cloning https://github.com/sqlmapproject/sqlmap -> $SRC"
  rm -rf "$SRC"
  git clone --depth 1 https://github.com/sqlmapproject/sqlmap "$SRC"
fi

printf '#!/bin/sh\nexec python3 "%s/sqlmap.py" "$@"\n' "$SRC" > "$DEST/sqlmap"
chmod +x "$DEST/sqlmap"
echo "[ok] sqlmap ready: $DEST/sqlmap"
"$DEST/sqlmap" --version 2>/dev/null | head -n 1 || true
