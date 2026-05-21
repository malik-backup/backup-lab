#!/usr/bin/env bash
set -Eeuo pipefail

# ==========================================
# backup.sh - Backup local/remote via rsync
# - Uses config file: scripts/backup.conf
# - Writes logs to: $LOGDIR/backup-YYYY-MM-DD.log
# - Supports DRY_RUN=1
# ==========================================

# === CONFIGURATION ===
CONF_FILE="$(dirname "$0")/backup.conf"

if [[ ! -f "$CONF_FILE" ]]; then
  echo "[FATAL] config file not found: $CONF_FILE" >&2
  exit 2
fi

# Load config (Shellcheck: sourced file)
# shellcheck disable=SC1090,SC1091
source "$CONF_FILE"
DRY_RUN="${DRY_RUN:-0}"

# --- LOGGING ---
mkdir -p "$LOGDIR" 
LOG="$LOGDIR/backup-$(date +%F).log"
log_info() {
  echo "$(date '+%F %T') [INFO] $*" >> "$LOG"
}

log_error() {
  echo "$(date '+%F %T') [ERROR] $*" | tee -a "$LOG" >&2
}

# Validate KEEP (must be a positive integer)
[[ "${KEEP:-}" =~ ^[0-9]+$ ]] || { log_error "KEEP must be a number"; exit 3; }

# Validate DRY_RUN (must be 0 or 1)
[[ "${DRY_RUN}" =~ ^[01]$ ]] || { log_error "DRY_RUN must be 0 or 1"; exit 3; }

# --- ERROR HANDLING ---
# shellcheck disable=SC2317
on_error() {
local code="$1"
  local lineno="$2"
  log_error "FAILED (exit=$code) at line $lineno"
  exit "$code"
}

# shellcheck disable=SC2154
trap 'on_error $? $LINENO' ERR


# --- COMMAND WRAPPER (DRY_RUN support) ---
run_cmd() {
  if [[ "$DRY_RUN" = "1" ]]; then
    log_info "DRY-RUN: $*"
    return 0
  else
    "$@" >>"$LOG" 2>&1
  fi
}

# --- BACKUP RUN ---
TS=$(date +%F_%H-%M-%S)
TARGET="$DEST/$TS"

log_info "RUN started"

# safety: never overwrite an existing backup
if [[ -d "$TARGET" ]]; then
log_error "backup $TARGET already exists"
  exit 1
fi

run_cmd mkdir -p "$TARGET"

run_cmd rsync -av \
  --exclude='.git' \
  --exclude='backups' \
  --exclude='logs' \
  "$SRC/" "$TARGET/"
if [[ "$DRY_RUN" != "1" ]]; then
log_info "rsync succeeded"
fi

# --- INTEGRITY MANIFEST (SHA-256) ---
# Generated while data is fresh: reference for the restore test.
CHECKSUM_FILE="${CHECKSUM_FILE:-checksums.sha256}"
if [[ "$DRY_RUN" = "1" ]]; then
  log_info "DRY-RUN: would generate manifest $TARGET/$CHECKSUM_FILE"
else
  (
    cd "$TARGET" || exit 1
    find . -type f ! -name "$CHECKSUM_FILE" -print0 \
      | sort -z \
      | xargs -0 sha256sum > "$CHECKSUM_FILE"
  )
  log_info "manifest generated ($(wc -l < "$TARGET/$CHECKSUM_FILE") files)"
fi
# --- ROTATION (keep last $KEEP) ---
# Safety checks before rotation
[[ -n "${DEST:-}" ]] || { log_error "DEST is empty"; exit 3; }
[[ "$DEST" != "/" ]] || { log_error "DEST cannot be /"; exit 3; }
cd "$DEST" || { log_error "cannot cd to DEST=$DEST"; exit 1; }
TO_DELETE=$(
  printf '%s\n' */ 2>/dev/null | sed 's:/$::' | sort | head -n -"${KEEP}" || true
)

if [[ "$DRY_RUN" = "1" ]]; then
  log_info "DRY-RUN: would delete:"
  while IFS= read -r b; do
    [[ -n "$b" ]] && log_info "  $b"
  done <<< "$TO_DELETE"
else
  echo "$TO_DELETE" | xargs -r rm -rf
fi

log_info "RUN finished successfully"
exit 0
