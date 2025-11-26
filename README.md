**Bitcoind Docker Images**

This repository provides automated Docker images for Bitcoin Core (bitcoind), built for every official release published on the Bitcoin Core GitHub repository.

**Features**

- Fully automated build system using GitHub Actions
- Automatic detection of new Bitcoin Core versions
- Automatic creation of a new branch for every version (v28.0, v28.1, v30.0, etc.)
- Docker images built per branch
- Cosign signing for all pushed images
- Images pushed to GitHub Container Registry (GHCR)
- Repository can remain private, while images are public

**Branching Strategy**

Every Bitcoin Core version is stored in its own branch:

- v28.0
- v28.1
- v29.2
- v30.0
- etc.

Each branch contains:
- A version-specific Dockerfile
- A GitHub Actions workflow that builds that version
- No manual version bumping required

When Bitcoin Core publishes a new release, the repository automatically:
- Detects the new version
- Creates a new branch (vX.Y.Z)
- Runs the build
- Pushes the Docker image
- Signs it with Cosign

**Usage Example**

Run a Bitcoin Core node:
```
docker run -d \
  --name bitcoind \
  -v /your/data/dir:/bitcoin/.bitcoin \
  -p 8332:8332 \
  -p 8333:8333 \
  ghcr.io/anym001/bitcoind:v30.0
```

**Configuration**

Place optional config in:
```
/bitcoin/.bitcoin/bitcoin.conf
```

**Cosign Signing**

Images are signed using Sigstore Keyless Signing, which means:
- No keys needed
- GitHub Actions identity is used
- Your signature is verifiable through Sigstore transparency logs

Users can verify your images with:
```
cosign verify ghcr.io/anym001/bitcoind:v30.0
```

**Contributing**

Pull requests are welcome - especially improvements to:
- Docker security hardening
- Automated workflows
- Cosign verification examples
