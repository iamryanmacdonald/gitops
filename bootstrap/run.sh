#!/usr/bin/env bash
set -eoux pipefail

kubectl create namespace security
sops --decrypt "${ROOT_DIR}/bootstrap/bitwarden.sops.yaml" | kubectl apply -f -
sops --decrypt "${ROOT_DIR}/bootstrap/cluster-secrets.sops.yaml" | kubectl apply -f -

helmfile --file "${ROOT_DIR}/bootstrap/helmfile.yaml" apply --hide-notes --skip-diff-on-install --suppress-diff --suppress-secrets