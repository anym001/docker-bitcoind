# Security Policy

## Reporting a Vulnerability

Please **do not** report security vulnerabilities through public GitHub
issues, discussions, or pull requests.

Instead, use GitHub's **private vulnerability reporting**:

1. Open the [**Security**](https://github.com/anym001/docker-bitcoind/security)
   tab of this repository.
2. Click **"Report a vulnerability"** to open a private security advisory.

This keeps the report confidential between you and the maintainer until a fix
is available.

### What to include

- A description of the vulnerability and its impact
- Steps to reproduce (proof of concept, affected image tag, configuration)
- Any suggested mitigation, if known

### What to expect

- Acknowledgement of your report as soon as possible.
- An assessment and, where applicable, a fix published as a new image tag.
- Coordinated disclosure — please allow a reasonable window before any public
  disclosure.

## Scope

This repository packages upstream [Bitcoin Core](https://github.com/bitcoin/bitcoin)
into Docker images. Vulnerabilities in **Bitcoin Core itself** should be
reported upstream following their
[security process](https://bitcoincore.org/en/contact/). Use this repository's
private reporting for issues in the **image, build, verification, or entrypoint**
(e.g. checksum/signature verification, privilege handling, base image).

## Supported Versions

Security fixes are provided for the **latest released image tag** only. Always
run the most recent tag.
