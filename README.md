# MailHog Multi-Architecture Docker Image

<div align="center">
  <img src="https://img.shields.io/docker/pulls/rijoanul/mailhog?style=for-the-badge&logo=docker&color=2496ED" alt="Docker Pulls">
  <img src="https://img.shields.io/docker/image-size/rijoanul/mailhog/latest?style=for-the-badge&logo=docker&color=2496ED" alt="Docker Image Size">
  <img src="https://img.shields.io/badge/architectures-amd64%20%7C%20arm64%20%7C%20armv8-blue?style=for-the-badge" alt="Supported Architectures">
</div>

## Overview

This repository provides a multi-architecture Docker image for MailHog, an open-source email testing tool for developers. It's built to run natively across different hardware platforms without emulation overhead.

### Supported Architectures
- `linux/amd64` (x86_64)
- `linux/arm64` (64-bit ARM)
- `linux/arm/v7` (32-bit ARM)

## Quick Start

Pull the image from Docker Hub:
```bash
docker pull rijoanul/mailhog:latest
```

Run the container:
```bash
docker run -d \
  --name mailhog \
  -p 1025:1025 \
  -p 8025:8025 \
  rijoanul/mailhog:latest
```

### Ports
- **1025**: SMTP Server (use this to send emails from your application)
- **8025**: Web UI (use this to view captured emails in your browser)

## Usage

This image is a drop-in replacement for the standard MailHog image and is particularly useful for:
- Local development on Apple Silicon (M1/M2/M3) Macs or ARM-based Linux machines.
- Standardizing email testing in CI/CD pipelines across mixed hardware environments.
- Debugging email routing and formatting without relying on external SMTP providers.

## Security & Reliability

The image is built with modern container best practices in mind:
- **Non-root execution**: The application runs as a dedicated `mailhog` user, not root.
- **Healthchecks**: Includes a built-in Docker `HEALTHCHECK` that queries the MailHog API, making it safe for container orchestrators like Kubernetes or Docker Swarm.
- **Reproducible builds**: The Dockerfile builds from a pinned MailHog release (v1.0.1) using Go's legacy GOPATH mode to guarantee consistent behavior despite MailHog's age.
- **Minimal footprint**: Based on Alpine Linux to keep the image lightweight and reduce the attack surface.

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | The most recent stable build |
| `v1.0.0` | Specific version pinning |

## Contributing

Pull requests and issues are welcome. Feel free to open a ticket if you run into any problems or have suggestions for improvements.

## License

Distributed under the MIT License.

## Connect

[@rijoanul](https://github.com/Rijoanul-Shanto)