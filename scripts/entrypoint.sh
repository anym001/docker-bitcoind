#!/usr/bin/env bash
set -euo pipefail

# Apply umask
umask "${UMASK:-022}"

# Resolve target uid/gid
TARGET_UID="${PUID:-$(id -u "$APP_USER")}"
TARGET_GID="${PGID:-$(id -g "$APP_USER")}"

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

# Ensure datadir exists
mkdir -p "$DATA_DIR"

# Fix ownership if empty or ownership mismatch
CURRENT_UID=$(stat -c %u "$DATA_DIR")
CURRENT_GID=$(stat -c %g "$DATA_DIR")

if [ -z "$(ls -A "$DATA_DIR")" ] || [ "$CURRENT_UID" != "$TARGET_UID" ] || [ "$CURRENT_GID" != "$TARGET_GID" ]; then
    echo "Fixing ownership and permissions of DATA_DIR..."
    chown -R "$TARGET_UID:$TARGET_GID" "$DATA_DIR"
    chmod "$DATA_PERM" "$DATA_DIR"
fi

# If no command was specified → default = bitcoind
if [[ $# -eq 0 ]]; then
    set -- bitcoind -printtoconsole
fi

# If first arg is a flag, prepend only "bitcoind"
if [[ "${1:0:1}" == "-" ]]; then
    set -- bitcoind "$@"
fi

# Append extra args
if [ -n "${BITCOIND_EXTRA_ARGS:-}" ]; then
    set -- "$@" ${BITCOIND_EXTRA_ARGS}
fi

echo "Starting bitcoind as UID:$TARGET_UID GID:$TARGET_GID"
exec gosu "$TARGET_UID:$TARGET_GID" "$@"
