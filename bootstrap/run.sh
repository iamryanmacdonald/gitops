#!/usr/bin/env bash
set -eoux pipefail

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/external-dns/refs/tags/v0.17.0/config/crd/standard/dnsendpoint.yaml
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.3.0/experimental-install.yaml
LATEST=$(curl -s https://api.github.com/repos/prometheus-operator/prometheus-operator/releases/latest | jq -cr .tag_name)
curl -sL https://github.com/prometheus-operator/prometheus-operator/releases/download/${LATEST}/stripped-down-crds.yaml | kubectl apply --server-side --filename -

helmfile --file "${ROOT_DIR}/bootstrap/helmfile.yaml" apply --hide-notes --skip-diff-on-install --suppress-diff --suppress-secrets