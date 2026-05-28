# Changelog

All notable changes to this image. Versions follow [SemVer](https://semver.org/).

## [0.3.0] - 2026-05-28

Same MailHog v1.0.1 image, now with a properly tested build pipeline and
supply-chain provenance.

### Added
- Multi-arch smoke tests (amd64, arm64, armv7) run on every PR and tag,
  with an SMTP round-trip that verifies mail actually reaches the store.
- Keyless `cosign` signing of every published image. Verify with:
  ```
  cosign verify rijoanul/mailhog:0.3.0 \
    --certificate-identity-regexp 'https://github.com/rijverse/mailhog-multi-arch/.*' \
    --certificate-oidc-issuer https://token.actions.githubusercontent.com
  ```
- SPDX SBOM attached as a cosign attestation. Pull with `cosign download attestation`.
- Trivy CVE scan on each build (HIGH/CRITICAL, fixed-only).
- Dependabot for Docker base images and GitHub Actions.
- Docker Compose snippet in the README.

### Changed
- Builder fetches the MailHog release tarball via `ADD` instead of cloning
  git. No more `git` package in the builder layer.
- `HEALTHCHECK` switched from a full message-list fetch to `wget --spider`,
  so probes don't serialize stored mail.
- Workflow runs read-only by default. Only the publish job opts into write
  scopes (`contents`, `packages`, `id-token`).
- Dropped the `type=sha` image tag for cleaner registry listings.
- Replaced the deprecated `maintainer` Dockerfile LABEL with
  `org.opencontainers.image.authors`. Removed labels that
  `docker/metadata-action` already injects.

### Docs
- README rewritten: shorter intro, key-value image table, less prose.

## Earlier releases

For `v0.2.x` and `v0.1.x`, see the auto-generated notes on the
[GitHub Releases page](https://github.com/rijverse/mailhog-multi-arch/releases).
