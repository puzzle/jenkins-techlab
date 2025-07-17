#!/bin/bash
set -euo pipefail

: "${TAG:?TAG is required}"
: "${DIGEST:?DIGEST is required}"

echo "🔍 Verifying image signature for: ${TAG}@${DIGEST}"

cosign verify \
  --certificate-identity-regexp ".*github.com/.*/.*/.github/workflows/.*" \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
  "${TAG}@${DIGEST}"

echo "✅ Verification successful."