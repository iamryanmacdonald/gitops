#!/usr/bin/env bash
set -eoux pipefail

LATEST=$(curl -s https://api.github.com/repos/kubernetes-sigs/external-dns/releases/latest | jq -cr .tag_name)
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/external-dns/refs/tags/${LATEST}/config/crd/standard/dnsendpoint.yaml
LATEST=$(curl -s https://api.github.com/repos/kubernetes-sigs/gateway-api/releases/latest | jq -cr .tag_name)
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/${LATEST}/experimental-install.yaml
LATEST=$(curl -s https://api.github.com/repos/prometheus-operator/prometheus-operator/releases/latest | jq -cr .tag_name)
curl -sL https://github.com/prometheus-operator/prometheus-operator/releases/download/${LATEST}/stripped-down-crds.yaml | kubectl apply --server-side --filename -

sops --decrypt "${ROOT_DIR}/kubernetes/clusters/${CLUSTER}/secrets/sops-age.sops.yaml" | kubectl apply -f -

helmfile --file "${ROOT_DIR}/bootstrap/helmfile.yaml" apply --hide-notes --skip-diff-on-install --suppress-diff --suppress-secrets