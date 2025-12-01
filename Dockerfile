FROM debian:stable-slim

ENV APP_USER=bitcoin \
    APP_USER_HOME=/home/bitcoin \
    DATA_DIR=/home/bitcoin/.bitcoin \
    DATA_PERM=2770 \
    UMASK=002 \
    BITCOIND_EXTRA_ARGS=""

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates gosu bash \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d ${APP_USER_HOME} -s /usr/sbin/nologin ${APP_USER} \
    && mkdir -p ${DATA_DIR} \
    && chown -R ${APP_USER}:${APP_USER} ${DATA_DIR} \
    && chmod ${DATA_PERM} ${DATA_DIR}

COPY bin/ /usr/local/bin/
RUN chown -R root:root /usr/local/bin \
    && chmod 0755 /usr/local/bin/*

COPY scripts/ /opt/scripts/
RUN chown -R root:root /opt/scripts \
    && chmod -R 0755 /opt/scripts/

EXPOSE 8333 8332

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
