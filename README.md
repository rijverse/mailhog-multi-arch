# MailHog Multi-Arch Docker Image

![Docker Pulls](https://img.shields.io/docker/pulls/rijoanul/mailhog?logo=docker)
![Image Size](https://img.shields.io/docker/image-size/rijoanul/mailhog/latest?logo=docker)
![Build](https://github.com/rijverse/mailhog-multi-arch/actions/workflows/docker-publish.yml/badge.svg)

Multi-arch Docker image for [MailHog](https://github.com/mailhog/MailHog), the dev SMTP server with a web UI. Adds `arm64` and `armv7` alongside the original `amd64`, since upstream stopped shipping in 2020.

## Run

```bash
docker run -d -p 1025:1025 -p 8025:8025 rijoanul/mailhog
```

Or with Compose:

```yaml
services:
  mailhog:
    image: rijoanul/mailhog
    ports: ["1025:1025", "8025:8025"]
```

Send mail to `localhost:1025`, read it at `http://localhost:8025`.

## Image

|  |  |
|---|---|
| Registries | `rijoanul/mailhog`, `ghcr.io/rijverse/mailhog` |
| Platforms | `linux/amd64`, `linux/arm64`, `linux/arm/v7` |
| Base | `alpine:3.21`, runs as `mailhog` (UID 1000) |
| MailHog | `v1.0.1` (pinned) |

`HEALTHCHECK` is built in, so Compose, Swarm, and Kubernetes can tell when it's ready.

## Tags

| Tag | Points to |
|---|---|
| `latest` | newest release |
| `X.Y.Z` | a specific release |
| `X.Y` | latest patch on that minor line |

Image versions track this repo's releases, not MailHog's.

## License

MIT.