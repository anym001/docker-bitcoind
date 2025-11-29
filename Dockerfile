FROM debian:stable-slim

ENV APP_USER=bitcoin \
    DATA_DIR=/home/bitcoin/.bitcoin \
    START_PARAMS="" \
    UMASK=0000 \
    DATA_PERM=0770 \
    BITCOIN_EXTRA_ARGS=""

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates gosu bash \
    && update-ca-certificates \
    && useradd -m -s /usr/sbin/nologin ${APP_USER} \
    && rm -rf /var/lib/apt/lists/*

COPY bin/ /usr/local/bin/
RUN chown -R root:root /usr/local/bin \
    && chmod 0755 /usr/local/bin/* \
    && chmod +x /usr/local/bin/*

COPY scripts/ /opt/scripts/
RUN chmod -R ${DATA_PERM} /opt/scripts/

VOLUME ["${DATA_DIR}"]

USER root

EXPOSE 8333 8332

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
