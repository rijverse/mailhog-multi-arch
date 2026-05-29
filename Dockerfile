# Build the builder natively on the host platform and cross-compile to the
# target arch. This avoids running the whole toolchain under QEMU emulation.
FROM --platform=$BUILDPLATFORM golang:1.26.3-alpine3.23 AS builder

# Pinned MailHog release. The single source of truth for what the image bundles.
ARG MAILHOG_VERSION=v1.0.1

# Work inside GOPATH so GO111MODULE=off can resolve the vendored deps.
WORKDIR /go/src/github.com/mailhog/MailHog

# Fetch the source tarball directly. No git needed in the builder, and
# BuildKit caches the URL content for us.
ADD https://github.com/mailhog/MailHog/archive/refs/tags/${MAILHOG_VERSION}.tar.gz /tmp/mailhog.tgz
RUN tar -xzf /tmp/mailhog.tgz --strip-components=1 && rm /tmp/mailhog.tgz

# Provided by Docker buildx for the target platform.
ARG TARGETARCH
ARG TARGETVARIANT

# Cross-compile. GOARM is derived from the buildx variant (e.g. "v7" -> "7")
# and is ignored by Go for non-arm targets.
RUN CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT#v} \
    GO111MODULE=off \
    go build -trimpath -ldflags='-s -w' -o /app/mailhog

FROM alpine:3.23

# Runtime CA certs + a dedicated non-root user.
RUN apk add --no-cache ca-certificates && \
    addgroup -g 1000 mailhog && \
    adduser -u 1000 -G mailhog -s /bin/sh -D mailhog

COPY --from=builder /app/mailhog /usr/local/bin/mailhog

LABEL org.opencontainers.image.authors="Rijoanul Hasan <rijoanul.shanto@gmail.com>"
# Note: image.source / image.description / image.version / image.revision are
# injected at build time by docker/metadata-action, so no need to hardcode them.

# SMTP and Web UI / API ports.
EXPOSE 1025 8025

USER mailhog

# busybox wget is part of the alpine base image. --spider does a HEAD-style
# check so we don't serialize every stored message on each probe.
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost:8025/

ENTRYPOINT ["/usr/local/bin/mailhog"]
