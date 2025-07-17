#!/bin/bash

set -euo pipefail

# Required environment variables
: "${ORG:?Missing ORG}"
: "${PACKAGE_NAME:?Missing PACKAGE_NAME}"
: "${PACKAGE_TYPE:?Missing PACKAGE_TYPE}"
: "${TAG:?Missing TAG}"
: "${LOGIN_TOKEN:?Missing LOGIN_TOKEN}"

# Prepare GitHub API headers
AUTH_HEADER="Authorization: Bearer ${LOGIN_TOKEN}"
ACCEPT_HEADER="Accept: application/vnd.github+json"
API_VERSION_HEADER="X-GitHub-Api-Version: 2022-11-28"

# Retrieve package versions
curl -L -s \
  -H "$ACCEPT_HEADER" \
  -H "$AUTH_HEADER" \
  -H "$API_VERSION_HEADER" \
  https://api.github.com/orgs/${ORG}/packages/${PACKAGE_TYPE}/${PACKAGE_NAME}/versions > versions.json

# Remove PR tag
PACKAGE_VERSION_ID=$(jq -r ".[] | select(.metadata.container.tags[]? == \"${TAG}\") | .id" versions.json)

if [[ -n "$PACKAGE_VERSION_ID" ]]; then
  echo "🔍 Found tagged image ($TAG), deleting version ID: $PACKAGE_VERSION_ID"
  curl -L -s -X DELETE \
    -H "$ACCEPT_HEADER" \
    -H "$AUTH_HEADER" \
    -H "$API_VERSION_HEADER" \
    https://api.github.com/orgs/${ORG}/packages/${PACKAGE_TYPE}/${PACKAGE_NAME}/versions/${PACKAGE_VERSION_ID}
  echo "✅ Deleted tag: $TAG"
else
  echo "ℹ️ No tag '$TAG' found in registry"
fi

# Remove untagged images
jq -r '.[] | select((.metadata.container.tags? // []) | length == 0) | .id' versions.json | while read -r id; do
  echo "🧹 Deleting untagged package ID: $id"
  curl -L -s -X DELETE \
    -H "$ACCEPT_HEADER" \
    -H "$AUTH_HEADER" \
    -H "$API_VERSION_HEADER" \
    https://api.github.com/orgs/${ORG}/packages/${PACKAGE_TYPE}/${PACKAGE_NAME}/versions/$id
done

echo "🏁 Registry cleanup completed."