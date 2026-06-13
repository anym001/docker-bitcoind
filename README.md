# Bitcoind Docker Images

[![Build](https://github.com/anym001/docker-bitcoind/actions/workflows/build-docker.yml/badge.svg)](https://github.com/anym001/docker-bitcoind/actions/workflows/build-docker.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![GHCR](https://img.shields.io/badge/GHCR-docker--bitcoind-2496ED?logo=docker&logoColor=white)](https://github.com/anym001/docker-bitcoind/pkgs/container/docker-bitcoind)

This repository provides automated, verified, and signed Docker images for Bitcoin Core (bitcoind).
Images are built for all official releases starting from v28.0 and pushed to GitHub Container Registry (GHCR).
All binaries are verified using the official SHA256SUMS and signed checksums.

The workflow automatically detects new releases from bitcoin/bitcoin and triggers the Docker build.
The latest tag is set only for the newest official release.

## Contents

- [Usage](#usage)
- [Configuration](#configuration)
- [Environment Variables](#environment-variables)
- [Security](#security)
- [Automated Build System](#automated-build-system)
- [Contributing](#contributing)

## Usage

Minimal example:

```
docker run -d \
  --name bitcoind \
  -v /your/data/dir:/home/bitcoin/.bitcoin \
  -p 8333:8333 \
  -p 8332:8332 \
  ghcr.io/anym001/docker-bitcoind:<version>
```

With permissions mapping and extra args:

```
docker run -d \
  --name bitcoind \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -e BITCOIND_EXTRA_ARGS="-txindex=1 -listen=1" \
  -v /your/data/dir:/home/bitcoin/.bitcoin \
  -p 8333:8333 \
  -p 8332:8332 \
  ghcr.io/anym001/docker-bitcoind:<version>
```

Tags:

- `<version>` — e.g., 29.2, 30.0 (always built for each release)
- `<version>-stable` — e.g., 29-stable, 30-stable
- `latest` — points to the latest official release

## Configuration

If you want custom configuration, place a `bitcoin.conf` file inside your mounted directory:

```
/your/data/dir/bitcoin.conf
```

Inside the container this becomes:

```
/home/bitcoin/.bitcoin/bitcoin.conf
```

Example:

```
server=1
daemon=0

# RPC
listen=1
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0

# ZMQ
zmqpubrawblock=tcp://0.0.0.0:28332
zmqpubrawtx=tcp://0.0.0.0:28333
```

If no config exists, Bitcoin Core will run with defaults.

## Environment Variables

| Variable            | Description                                                   |
| :------------------ | :------------------------------------------------------------ |
| `PUID`              | Container user UID (maps to host UID). Optional.              |
| `PGID`              | Container group GID (maps to host GID). Optional.             |
| `UMASK`             | Default file creation mask inside the container. Default: 002 |
| `DATA_PERM`         | Permission mode applied to the data directory. Default: 2770  |
| `BITCOIND_EXTRA_ARGS` | Additional arguments appended to the bitcoind command.      |

## Security

This image is designed with safety in mind:

- Runs as non-root user `bitcoin`
- Uses minimal base image (`debian:stable-slim`)
- Binaries are GPG-verified using the official Guix builder keys
- No unnecessary packages installed
- Ensures safe access to the mounted volume using `PUID`, `PGID`, and `UMASK`

## Automated Build System

1. `release-check.yml` workflow:
   - Checks all official Bitcoin Core releases
   - Determines which releases are missing in your repo
   - Triggers `build-docker.yml` for missing releases
   - Passes `LATEST=true` for the newest release

2. `build-docker.yml` workflow:
   - Downloads official binaries and verifies SHA256 + PGP signatures
   - Extracts required binaries (`bitcoind`, `bitcoin-cli`)
   - Builds and pushes Docker images to GHCR
   - Creates a GitHub Release for each version

## Contributing

PRs are welcome, especially improvements to:

- Docker security hardening
- Improving automated workflows
- Enhancing testing or verification
- Image signing and supply-chain security
- Documentation

## License

The contents of this repository (Dockerfile, scripts, and workflows) are
licensed under the [MIT License](LICENSE).

This project only packages Bitcoin Core into Docker images; the upstream
source code is not modified or redistributed in this repository.
[Bitcoin Core](https://github.com/bitcoin/bitcoin) is distributed under its
own MIT license, and all upstream copyrights and trademarks remain with their
respective owners.
