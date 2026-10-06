#!/usr/bin/env bash
# Build both overlays with the kustomize bundled in kubectl and assert the differences.
set -euo pipefail
cd "$(dirname "$0")"
dev=$(kubectl kustomize overlays/dev)
prod=$(kubectl kustomize overlays/prod)
grep -q 'name: dev-orders' <<<"$dev"
grep -q 'replicas: 1$' <<<"$dev"
grep -q 'orders:1.0.0-SNAPSHOT' <<<"$dev"
grep -q 'namespace: orders-prod' <<<"$prod"
grep -q 'replicas: 4$' <<<"$prod"
grep -q 'memory: 1Gi' <<<"$prod"
echo "kustomize-overlays OK"
