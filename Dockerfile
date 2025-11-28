FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && useradd -m -s /usr/sbin/nologin bitcoin \
    && rm -rf /var/lib/apt/lists/*

RUN chown -R bitcoin:bitcoin /home/bitcoin

COPY bin/ /usr/local/bin/
RUN chown -R root:root /usr/local/bin && chmod +x /usr/local/bin/*

VOLUME ["/home/bitcoin/.bitcoin"]

USER bitcoin
EXPOSE 8333 8332

ENTRYPOINT ["bitcoind"]
CMD ["-printtoconsole"]
