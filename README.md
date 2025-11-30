# Bitcoind Docker Images

This repository provides automated, verified, and signed Docker images for Bitcoin Core (bitcoind).
Images are built for all official releases starting from v28.0 and pushed to GitHub Container Registry (GHCR).
All binaries are verified using the official SHA256SUMS and signed checksums.

The workflow automatically detects new releases from bitcoin/bitcoin and triggers the Docker build.
The latest tag is set only for the newest official release.

## 🚀 Usage

Minimal example:

```
docker run -d \
  --name bitcoind \
  -v /your/data/dir:/home/bitcoin/.bitcoin \
  -p 8333:8333 \
  -p 8332:8332 \
  ghcr.io/anyp001/docker-bitcoind:<version>
```

With permissions mapping and extra args:

```
docker run -d \
  --name bitcoind \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -e DATA_PERM=2770 \
  -e DATA_DIR=/home/bitcoin/.bitcoin \
  -e BITCOIND_EXTRA_ARGS="-txindex=1 -listen=1" \
  -v /your/data/dir:/home/bitcoin/.bitcoin \
  -p 8333:8333 \
  -p 8332:8332 \
  ghcr.io/anyp001/docker-bitcoind:<version>
```

Tags:

- `<version>` → e.g., 29.2, 30.0 (always built for each release)
- `<version>-stable` → e.g., 29-stable, 30-stable
- `latest` → points to the latest official release

## ⚙️ Configuration

If you want custom configuration, place a bitcoin.conf file inside your mounted directory:

```
/your/data/dir/bitcoin.conf
```

Inside the container this becomes:

```
/home/bitcoin/.bitcoin/bitcoin.conf
```

If no config exists, Bitcoin Core will run with defaults.

## 🔧 Environment Variables

| Variable           | Description                                            |
| :----------------- | :----------------------------------------------------- |
| PUID               | Container user UID (maps to host UID). Optional.       |
| PGID               | Container group GID (maps to host GID). Optional.      |
| UMASK              | Default file creation mask inside the container. Default: 002 |
| DATA_PERM          | Permission mode applied to the data directory. Default: 2770 |
| DATA_DIR           | Path to the Bitcoin data directory inside the container. Default: /home/bitcoin/.bitcoin |
| BITCOIND_EXTRA_ARGS | Additional arguments appended to the bitcoind command. |

## 🔒 Security

This image is designed with safety in mind:

- Runs as non-root user bitcoin
- Uses minimal base image (debian:stable-slim)
- Binaries are GPG-verified using the official Guix builder keys
- No unnecessary packages installed
- Ensures safe access to the mounted volume using:
  - PUID
  - PGID
  - UMASK

## 🏗️ Automated Build System

1. release-check.yml workflow:

   - Checks all official Bitcoin Core releases
   - Determines which releases are missing in your repo
   - Triggers build-docker.yml for missing releases
   - Passes LATEST=true for the newest release

2. build-docker.yml workflow:
   - Downloads official binaries and verifies SHA256 + PGP signatures
   - Extracts required binaries (bitcoind, bitcoin-cli)
   - Builds and pushes Docker images to GHCR
   - Creates a GitHub Release for each version

## 🤝 Contributing

PRs are welcome, especially improvements to:

- Docker security hardening
- Improving automated workflows
- Enhancing testing or verification
- Image signing and supply-chain security
- Documentation
