**Bitcoind Docker Images**

This repository provides automated Docker images for Bitcoin Core (bitcoind).

**Usage Example**

Run a Bitcoin Core node:
```
docker run -d \
  --name bitcoind \
  -v /your/data/dir:/home/bitcoin/.bitcoin \
  -p 8332:8332 \
  -p 8333:8333 \
  ghcr.io/anym001/bitcoind:<version>
```

**Configuration**

Place optional config in:
```
/home/bitcoin/.bitcoin/bitcoin.conf
```

**Contributing**

Pull requests are welcome - especially improvements to:
- Docker security hardening
- Automated workflows
- etc.
