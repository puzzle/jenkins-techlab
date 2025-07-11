#!/bin/bash

set -euo pipefail

: "${TRAINING_HELM_RELEASE:?Missing release name}"
: "${TRAINING_NAMESPACE:?Missing namespace}"
: "${KUBE_CONFIG_PATH:?KUBE_CONFIG_PATH environment variable is required}"
: "${KUBE_CONFIG_FILENAME:?KUBE_CONFIG_FILENAME environment variable is required}"

echo "⛏️  Uninstalling Helm release: $TRAINING_HELM_RELEASE from namespace: $TRAINING_NAMESPACE"

helm uninstall "$TRAINING_HELM_RELEASE" \
  --namespace "$TRAINING_NAMESPACE" \
  --kubeconfig "$KUBE_CONFIG_PATH/$KUBE_CONFIG_FILENAME" \
  --ignore-not-found

echo "✅ Successfully cleaned up Helm release."
