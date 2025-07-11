#!/bin/bash

set -euo pipefail

: "${HELM_RELEASE:?HELM_RELEASE is required}"
: "${NAMESPACE:?NAMESPACE is required}"
: "${TRAINING_VERSION:?TRAINING_VERSION is required}"
: "${KUBE_CONFIG_PATH:?KUBE_CONFIG_PATH environment variable is required}"
: "${KUBE_CONFIG_FILENAME:?KUBE_CONFIG_FILENAME environment variable is required}"

echo "🚀 Deploying Helm release '$HELM_RELEASE' into namespace '$NAMESPACE'..."

helm upgrade "$HELM_RELEASE" acend-training-chart \
  --install \
  --wait \
  --kubeconfig "$KUBE_CONFIG_PATH/$KUBE_CONFIG_FILENAME" \
  --namespace "$NAMESPACE" \
  --set=app.name="$HELM_RELEASE" \
  --set=app.version="$TRAINING_VERSION" \
  --repo=https://acend.github.io/helm-charts/ \
  --values=helm-chart/values.yaml \
  --atomic

echo "✅ Helm release '$HELM_RELEASE' deployed successfully."