#!/usr/bin/env bash
# Render the chart per environment and assert the values took effect.
set -euo pipefail
cd "$(dirname "$0")"
dev=$(helm template orders orders -f values-dev.yaml)
prod=$(helm template orders orders -f values-prod.yaml)
grep -q 'replicas: 1$' <<<"$dev"
grep -q 'replicas: 4$' <<<"$prod"
grep -q 'value: "dev"' <<<"$dev"
grep -q 'value: "prod"' <<<"$prod"
echo "values-per-env OK"
