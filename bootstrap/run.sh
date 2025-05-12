#!/usr/bin/env bash
set -eoux pipefail

LATEST=$(curl -s https://api.github.com/repos/prometheus-operator/prometheus-operator/releases/latest | jq -cr .tag_name)
curl -sL https://github.com/prometheus-operator/prometheus-operator/releases/download/${LATEST}/stripped-down-crds.yaml | kubectl apply --server-side --filename -

helmfile --file "${ROOT_DIR}/bootstrap/helmfile.yaml" apply --hide-notes --skip-diff-on-install --suppress-diff --suppress-secrets