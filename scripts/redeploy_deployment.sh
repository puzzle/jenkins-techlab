#!/bin/bash

set -euo pipefail

: "${HELM_RELEASE:?HELM_RELEASE is required}"
: "${HELM_NAME:?HELM_NAME is required}"
: "${NAMESPACE:?NAMESPACE is required}"
: "${KUBE_CONFIG_PATH:?KUBE_CONFIG_PATH environment variable is required}"
: "${KUBE_CONFIG_FILENAME:?KUBE_CONFIG_FILENAME environment variable is required}"

DEPLOYMENT_NAME="${HELM_RELEASE}-${HELM_NAME}"

echo "♻️ Redeploying deployment '$DEPLOYMENT_NAME' in namespace '$NAMESPACE'..."

kubectl rollout restart deployment/"$DEPLOYMENT_NAME" \
  --kubeconfig "$KUBE_CONFIG_PATH/$KUBE_CONFIG_FILENAME" \
  --namespace "$NAMESPACE"

echo "✅ Deployment '$DEPLOYMENT_NAME' restarted successfully."
