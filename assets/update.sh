#!/usr/bin/env bash
set -euo pipefail

URL="https://cdn.jsdelivr.net/gh/Loyalsoldier/geoip@release/geoip.dat"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
DEST="$SCRIPT_DIR/geoip.dat"

TMP="$(mktemp "$SCRIPT_DIR/geoip.dat.tmp.XXXXXX")"

if wget -O "$TMP" "$URL" && [ -s "$TMP" ]; then
  mv -f "$TMP" "$DEST"
  echo "Updated $DEST"
else
  rm -f "$TMP"
  echo "Download failed or file empty; keeping existing $DEST" >&2
  exit 1
fi
