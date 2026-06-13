# Contributing

Thanks for your interest in improving the Bitcoind Docker images!
Contributions are welcome — especially around Docker hardening, the automated
build and verification workflows, and documentation.

## Ways to contribute

- **Bug reports & feature requests:** open an issue using the provided
  templates.
- **Security issues:** please report them privately — see
  [SECURITY.md](SECURITY.md). Do not open a public issue.
- **Pull requests:** see below.

## Pull requests

1. Fork the repository and create a branch from `main`.
2. Keep each PR focused on a single topic.
3. Make sure the image still builds and that all verification steps
   (checksum / signature / Guix key checks) remain intact.
4. Open a PR against `main` and describe what you changed and why.

Particularly welcome:

- Docker security hardening
- Improvements to the automated build / release workflows
- Better testing or verification
- Image signing and supply-chain security
- Documentation

## Conventions

- English everywhere (code, comments, commit messages, docs).
- Never commit secrets or credentials.
