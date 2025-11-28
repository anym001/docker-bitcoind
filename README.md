# Bitcoind Docker Images

This repository provides automated, verified, and signed Docker images for Bitcoin Core (bitcoind).  
Each version of Bitcoin Core is built from a dedicated branch (`v30.0`, `v29.2`, etc.).  
All binaries are verified using the official SHA256SUMS and signed checksums.

Images are built automatically via GitHub Actions and pushed to GHCR.

## 🚀 Usage

Run a Bitcoin Core node:

```
docker run -d \
  --name bitcoind \
  -v /your/data/dir:/home/bitcoin/.bitcoin \
  -p 8333:8333 \
  -p 8332:8332 \
  ghcr.io/anyp001/bitcoind:<version>
```

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

## 🔒 Security

This image is designed with safety in mind:
- Runs as non-root user bitcoin
- Uses minimal base image (debian:stable-slim)
- Binaries are GPG-verified using the official Guix builder keys
- No unnecessary packages installed

## 🏗️ Automated Build System

The CI pipeline performs:
1. Determine version from branch name (v30.0, etc.)
2. Download official Bitcoin Core binaries
3. Import builder keys
4. Verify:
    - Signature (SHA256SUMS.asc)
    - Hashes (sha256sum)
5. Extract only required binaries (bitcoind, bitcoin-cli)
6. Build the Docker image
7. Push image to GHCR:
    - ghcr.io/<user>/bitcoind:<version>
    - ghcr.io/<user>/bitcoind:<major>-stable
8. Create GitHub Release + tag automatically

## 🤝 Contributing

PRs are welcome, especially improvements to:
- Docker hardening
- CI verification steps
- Image signing and supply-chain security
- Documentation
