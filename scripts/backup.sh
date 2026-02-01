#!/bin/bash
set -euo pipefail

# === CONFIGURATION ===
CONF_FILE="$(dirname "$0")/backup.conf"

if [ ! -f "$CONF_FILE" ]; then
  echo "[FATAL] config file not found: $CONF_FILE"
  exit 2
fi

# charge la config
source "$CONF_FILE"

LOG="$LOGDIR/backup-$(date +%F).log"
log_info() {
  echo "$(date '+%F %T') [INFO] $1" >> "$LOG"
}

log_error() {
  echo "$(date '+%F %T') [ERROR] $1" >> "$LOG"
}

TS=$(date +%F_%H-%M-%S)
TARGET="$DEST/$TS"

log_info "RUN started"

# sécurité: ne jamais écraser un backup existant
if [ -d "$TARGET" ]; then
log_error "backup $TARGET already exists"
  exit 1
fi

mkdir -p "$TARGET"

rsync -av "$SRC/" "$TARGET/" >> "$LOG" 2>&1

log_info "rsync succeeded"

# === ROTATION DES BACKUPS ===
cd "$DEST" || exit 1
TO_DELETE=$(ls -1 | sort | head -n -"$KEEP" 2>/dev/null)

if [ -n "$TO_DELETE" ]; then
log_info "rotation: deleting old backups"
while IFS= read -r b; do
    [ -n "$b" ] && log_info "delete: $b"
  done <<< "$TO_DELETE"
  echo "$TO_DELETE" | xargs -r rm -rf
else
log_info "rotation: nothing to delete (keep last $KEEP)"
fi

exit 0
