FROM golang:1.21-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git build-base ca-certificates

# Set working directory to GOPATH so GO111MODULE=off can find the vendor folder
WORKDIR /go/src/github.com/mailhog/MailHog

# Clone MailHog repository (pinned to v1.0.1 for deterministic builds)
RUN git clone -b v1.0.1 --single-branch https://github.com/mailhog/MailHog.git .

# Use ARG for architecture - this will be passed by Docker buildx
ARG TARGETARCH
ARG TARGETVARIANT

# Build the application with proper architecture mapping
RUN echo "Building for architecture: $TARGETARCH" && \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=$TARGETARCH \
    GO111MODULE=off \
    go build -o /app/mailhog

FROM alpine:latest

# Add runtime dependencies and create a non-root user
RUN apk add --no-cache ca-certificates && \
    addgroup -g 1000 mailhog && \
    adduser -u 1000 -G mailhog -s /bin/sh -D mailhog

# Copy MailHog binary
COPY --from=builder /app/mailhog /usr/local/bin/mailhog

# Metadata
LABEL maintainer="Rijoanul Hasan <rijoanul.shanto@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/Rijoanul-Shanto/mailhog-multi-arch"
LABEL org.opencontainers.image.description="Multi-platform Mailhog Docker Image"

# Expose SMTP and HTTP ports
EXPOSE 1025 8025

# Switch to non-root user
USER mailhog

# Add healthcheck targeting the MailHog API
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -q -O - http://localhost:8025/api/v2/messages > /dev/null 2>&1 || exit 1

ENTRYPOINT ["/usr/local/bin/mailhog"]