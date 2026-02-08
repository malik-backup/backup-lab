#!/usr/bin/env bash
set -Eeuo pipefail

ARCHIVE_DIR="archives"
SOURCE_DIR="data"
KEEP=3

mkdir -p "$ARCHIVE_DIR"

timestamp=$(date +%Y%m%d-%H%M%S)
archive="$ARCHIVE_DIR/data-$timestamp.tar.gz"

echo "Creating archive: $archive"

tar -czf "$archive" "$SOURCE_DIR"

echo "Archive created successfully."

echo "Cleaning old archives (keeping last $KEEP)..."

ls -t "$ARCHIVE_DIR"/*.tar.gz | tail -n +$((KEEP+1)) | xargs -r rm -f

echo "Done."

