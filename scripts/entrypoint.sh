#!/usr/bin/env bash
set -euo pipefail

echo "-----------------------------------------------"
echo "Initializing bitcoind container environment..."
echo "-----------------------------------------------"

# Apply umask
umask "${UMASK:-022}"

# Ensure APP_USER_HOME is set
APP_USER_HOME="${APP_USER_HOME:-/home/$APP_USER}"

# Resolve target uid/gid
TARGET_UID="${PUID:-$(id -u "$APP_USER")}"
TARGET_GID="${PGID:-$(id -g "$APP_USER")}"

# Validate that PUID/PGID are integers
if ! [[ "$TARGET_UID" =~ ^[0-9]+$ ]] || ! [[ "$TARGET_GID" =~ ^[0-9]+$ ]]; then
    echo "Error: PUID and PGID must be integers (got PUID='$TARGET_UID' PGID='$TARGET_GID')" >&2
    exit 1
fi

# Update group if needed
if [ "$(id -g "$APP_USER")" != "$TARGET_GID" ]; then
    echo "Updating GID → $TARGET_GID"
    groupmod -o -g "$TARGET_GID" "$APP_USER"
fi

# Update user if needed
if [ "$(id -u "$APP_USER")" != "$TARGET_UID" ]; then
    echo "Updating UID → $TARGET_UID"
    usermod -o -u "$TARGET_UID" "$APP_USER"
fi

FINAL_DATADIR="$DATA_DIR"

# Check bitcoin.conf first (lower priority than CLI)
CONF_FILE="${APP_USER_HOME}/.bitcoin/bitcoin.conf"
if [ -f "$CONF_FILE" ]; then
    # Simple key=value parsing, ignores spaces around =
    CONF_DATADIR=$(grep -E '^\s*datadir\s*=' "$CONF_FILE" | tail -n1 | sed -E 's/^\s*datadir\s*=\s*//' || true)
    if [ -n "$CONF_DATADIR" ]; then
        FINAL_DATADIR="$CONF_DATADIR"
        echo "Detected datadir override from bitcoin.conf → $FINAL_DATADIR"
    fi
fi

# CLI argument overrides bitcoin.conf (highest priority)
for arg in "$@"; do
    if [[ "$arg" == -datadir=* ]]; then
        FINAL_DATADIR="${arg#-datadir=}"
        echo "Detected CLI datadir override → $FINAL_DATADIR"
        break
    fi
done

# Ensure datadir exists
mkdir -p "$FINAL_DATADIR"

# Fix ownership if empty or ownership mismatch
CURRENT_UID=$(stat -c %u "$FINAL_DATADIR")
CURRENT_GID=$(stat -c %g "$FINAL_DATADIR")

if [ -z "$(ls -A "$FINAL_DATADIR")" ] || \
   [ "$CURRENT_UID" != "$TARGET_UID" ] || \
   [ "$CURRENT_GID" != "$TARGET_GID" ]; then
    echo "Fixing ownership and permissions of DATA_DIR..."
    chown -R "$TARGET_UID:$TARGET_GID" "$FINAL_DATADIR"
    chmod "$DATA_PERM" "$FINAL_DATADIR"
    chmod g+s "$FINAL_DATADIR"
fi

# If no command was specified → default = bitcoind
if [[ $# -eq 0 ]]; then
    set -- bitcoind -printtoconsole
fi

# If first arg is a flag, prepend only "bitcoind"
if [[ "${1:0:1}" == "-" ]]; then
    set -- bitcoind "$@"
fi

# If user did not pass -datadir via CLI, add our FINAL_DATADIR
HAS_DATADIR_FLAG=false
for arg in "$@"; do
    if [[ "$arg" == -datadir=* ]]; then
        HAS_DATADIR_FLAG=true
        break
    fi
done

if [ "$HAS_DATADIR_FLAG" = false ]; then
    set -- "$@" -datadir="$FINAL_DATADIR"
fi

# Append extra args from BITCOIND_EXTRA_ARGS (safe word-splitting, no glob expansion)
if [ -n "${BITCOIND_EXTRA_ARGS:-}" ]; then
    IFS=' ' read -ra _extra_args <<< "$BITCOIND_EXTRA_ARGS"
    set -- "$@" "${_extra_args[@]}"
fi

echo "-----------------------------------------------"
echo "Starting bitcoind as UID:$TARGET_UID GID:$TARGET_GID"
echo "Using DATA_DIR: $FINAL_DATADIR"
echo "Command: $*"
echo "-----------------------------------------------"

exec gosu "$TARGET_UID:$TARGET_GID" "$@"
