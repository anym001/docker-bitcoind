#!/usr/bin/env bash
set -euo pipefail

# Apply umask
umask "${UMASK:-0000}"

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

# Ensure data directory exists
mkdir -p "$DATA_DIR"

# Only run chown if fresh datadir
if [ ! -d "$DATA_DIR/blocks" ]; then
    echo "Fixing ownership of DATA_DIR ..."
    chown -R "$TARGET_UID:$TARGET_GID" "$DATA_DIR"
fi

# Run initializer only if it exists
if [ -x /opt/scripts/init-bitcoind.sh ]; then
    export TARGET_UID TARGET_GID APP_USER DATA_DIR
    /opt/scripts/init-bitcoind.sh
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
if [ -n "${BITCOIN_EXTRA_ARGS:-}" ]; then
    set -- "$@" ${BITCOIN_EXTRA_ARGS}
fi

echo "Starting Bitcoin as UID:$TARGET_UID GID:$TARGET_GID"
exec gosu "$TARGET_UID:$TARGET_GID" "$@"
