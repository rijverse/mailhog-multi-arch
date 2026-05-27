# Build the builder natively on the host platform and cross-compile to the
# target arch. This avoids running the whole toolchain under QEMU emulation.
FROM --platform=$BUILDPLATFORM golang:1.21.13-alpine3.20 AS builder

# git + CA certs are required to clone MailHog over HTTPS.
RUN apk add --no-cache git ca-certificates

# Work inside GOPATH so GO111MODULE=off can resolve the vendored deps.
WORKDIR /go/src/github.com/mailhog/MailHog

# Clone MailHog (pinned to v1.0.1 for deterministic builds).
RUN git clone -b v1.0.1 --single-branch --depth 1 https://github.com/mailhog/MailHog.git .

# Provided by Docker buildx for the target platform.
ARG TARGETARCH
ARG TARGETVARIANT

# Cross-compile. GOARM is derived from the buildx variant (e.g. "v7" -> "7")
# and is ignored by Go for non-arm targets.
RUN echo "Building for ${TARGETARCH}${TARGETVARIANT}" && \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT#v} \
    GO111MODULE=off \
    go build -trimpath -ldflags='-s -w' -o /app/mailhog

FROM alpine:3.21

# Runtime CA certs + a dedicated non-root user.
RUN apk add --no-cache ca-certificates && \
    addgroup -g 1000 mailhog && \
    adduser -u 1000 -G mailhog -s /bin/sh -D mailhog

COPY --from=builder /app/mailhog /usr/local/bin/mailhog

LABEL maintainer="Rijoanul Hasan <rijoanul.shanto@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/Rijoanul-Shanto/mailhog-multi-arch"
LABEL org.opencontainers.image.description="Multi-platform MailHog Docker Image"

# SMTP and Web UI / API ports.
EXPOSE 1025 8025

USER mailhog

# busybox wget is part of the alpine base image.
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -q -O - http://localhost:8025/api/v2/messages > /dev/null 2>&1 || exit 1

ENTRYPOINT ["/usr/local/bin/mailhog"]
