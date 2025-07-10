#!/bin/bash

set -euo pipefail

: "${KUBE_CONFIG:?KUBE_CONFIG environment variable is required}"
: "${KUBE_CONFIG_PATH:?KUBE_CONFIG_PATH environment variable is required}"
: "${KUBE_CONFIG_FILENAME:?KUBE_CONFIG_FILENAME environment variable is required}"

echo "📄 Writing kubeconfig to \$KUBE_CONFIG_PATH/\$KUBE_CONFIG_FILENAME ($KUBE_CONFIG_PATH/$KUBE_CONFIG_FILENAME) ..."
mkdir -p $KUBE_CONFIG_PATH
echo "$KUBE_CONFIG" > "$KUBE_CONFIG_PATH/$KUBE_CONFIG_FILENAME"
echo "✅ Kubeconfig written successfully."
