#!/usr/bin/env bash

set -e

SRC="data"
DEST="archives"
TS=$(date +%Y%m%d-%H%M%S)

mkdir -p "$DEST"

tar -czf "$DEST/data-$TS.tar.gz" "$SRC"

echo "Archive created: $DEST/data-$TS.tar.gz"

