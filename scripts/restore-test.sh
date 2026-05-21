#!/usr/bin/env bash
set -Eeuo pipefail

# ==========================================
# restore-test.sh - Automated restore test
# - Restores the latest backup into an ISOLATED tmp dir
# - Verifies integrity via sha256sum -c (manifest from backup.sh)
# - Never touches source data or the backups themselves
# - Supports DRY_RUN=1
#
# Exit codes:
#   0  restore verified (backup is restorable)
#   1  environment error (cd, restore)
#   2  integrity failed (corruption) / manifest missing
#   3  configuration error
# ==========================================

CONF_FILE="$(dirname "$0")/backup.conf"

if [[ ! -f "$CONF_FILE" ]]; then
  echo "[FATAL] config file not found: $CONF_FILE" >&2
  exit 2
fi

# shellcheck disable=SC1090,SC1091
source "$CONF_FILE"
DRY_RUN="${DRY_RUN:-0}"
CHECKSUM_FILE="${CHECKSUM_FILE:-checksums.sha256}"

mkdir -p "$LOGDIR"
LOG="$LOGDIR/restore-test-$(date +%F).log"
log_info() {
  echo "$(date '+%F %T') [INFO] $*" >> "$LOG"
}

log_error() {
  echo "$(date '+%F %T') [ERROR] $*" | tee -a "$LOG" >&2
}

# Validate DRY_RUN (must be 0 or 1)
[[ "${DRY_RUN}" =~ ^[01]$ ]] || { log_error "DRY_RUN must be 0 or 1"; exit 3; }

# --- error handling + cleanup ---
RESTORE_TMP=""

# shellcheck disable=SC2317
on_error() {
  local code="$1"
  local lineno="$2"
  log_error "FAILED (exit=$code) at line $lineno"
  exit "$code"
}

# shellcheck disable=SC2317
cleanup() {
  if [[ -n "$RESTORE_TMP" && -d "$RESTORE_TMP" ]]; then
    rm -rf "$RESTORE_TMP"
    log_info "cleanup: removed $RESTORE_TMP"
  fi
}

# shellcheck disable=SC2154
trap 'on_error $? $LINENO' ERR
trap cleanup EXIT

# --- safety checks ---
[[ -n "${DEST:-}" ]]   || { log_error "DEST is empty"; exit 3; }
[[ -d "${DEST:-}" ]]   || { log_error "DEST not found: $DEST"; exit 3; }
[[ -n "${LOGDIR:-}" ]] || { log_error "LOGDIR is empty"; exit 3; }

log_info "RESTORE-TEST started"

# --- find latest backup ---
LATEST=$(
  cd "$DEST" || { log_error "cannot cd to DEST=$DEST"; exit 1; }
  printf '%s\n' */ 2>/dev/null | sed 's:/$::' | sort | tail -n 1
)
[[ -n "$LATEST" ]] || { log_error "no backup found in $DEST"; exit 1; }
BACKUP_DIR="$DEST/$LATEST"
log_info "testing backup: $LATEST"

# --- restore to isolated tmp ---
if [[ -n "${RESTORE_TMP_PARENT:-}" ]]; then
  mkdir -p "$RESTORE_TMP_PARENT"
  RESTORE_TMP=$(mktemp -d "$RESTORE_TMP_PARENT/restore-test.XXXXXX")
else
  RESTORE_TMP=$(mktemp -d)
fi
log_info "restoring to isolated tmp: $RESTORE_TMP"

if [[ "$DRY_RUN" = "1" ]]; then
  log_info "DRY-RUN: rsync -a $BACKUP_DIR/ $RESTORE_TMP/"
  log_info "DRY-RUN: sha256sum -c $CHECKSUM_FILE (in $RESTORE_TMP)"
  log_info "DRY-RUN: restore test simulated"
  log_info "RESTORE-TEST finished successfully"
  exit 0
fi

rsync -a "$BACKUP_DIR/" "$RESTORE_TMP/" >>"$LOG" 2>&1
log_info "restore completed"

# --- verify integrity ---
MANIFEST="$RESTORE_TMP/$CHECKSUM_FILE"
if [[ ! -f "$MANIFEST" ]]; then
  log_error "manifest missing in backup: $CHECKSUM_FILE"
  log_error "was this backup created by a backup.sh version that generates manifests?"
  exit 2
fi

log_info "verifying integrity (sha256sum -c)"

CHECK_RC=0
CHECK_OUT=$( cd "$RESTORE_TMP" && sha256sum -c "$CHECKSUM_FILE" 2>&1 ) || CHECK_RC=$?

TOTAL=$(wc -l < "$MANIFEST")
FAILED=$(grep -c ': FAILED$' <<< "$CHECK_OUT" || true)
OK=$(( TOTAL - FAILED ))

if [[ "$CHECK_RC" -eq 0 ]]; then
  log_info "integrity OK: $OK/$TOTAL files verified"
  log_info "RESTORE TEST PASSED - backup is restorable"
  log_info "RESTORE-TEST finished successfully"
  exit 0
else
  log_error "integrity KO: $FAILED/$TOTAL files corrupted"
  while IFS= read -r bad; do
    [[ -n "$bad" ]] && log_error "corrupted: ${bad%%: FAILED*}"
  done < <(grep ': FAILED$' <<< "$CHECK_OUT")
  log_error "RESTORE TEST FAILED - do NOT trust this backup"
  exit 2
fi
