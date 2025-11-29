#!/usr/bin/env bash
set -euo pipefail

TARGET_UID="${TARGET_UID:-$(id -u "${APP_USER:-bitcoin}")}"
TARGET_GID="${TARGET_GID:-$(id -g "${APP_USER:-bitcoin}")}"
CONF_PATH="${DATA_DIR}/bitcoin.conf"

if [ ! -f "$CONF_PATH" ]; then
    echo "No bitcoin.conf found → generating default config"

    RPCUSER="${RPCUSER:-bitcoinrpc}"
    RPCPASSWORD="${RPCPASSWORD:-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 32)}"
    RPCALLOWIP="${RPCALLOWIP:-127.0.0.1}"

cat <<EOF > "$CONF_PATH"
server=1
daemon=0
txindex=1

rpcuser=${RPCUSER}
rpcpassword=${RPCPASSWORD}
rpcallowip=${RPCALLOWIP}
EOF

    echo "Created default bitcoin.conf"
fi

chown "$TARGET_UID:$TARGET_GID" "$CONF_PATH"
