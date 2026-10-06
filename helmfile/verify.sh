#!/usr/bin/env bash
# Needs the helmfile binary (and helm). Renders both environments without a cluster.
set -euo pipefail
cd "$(dirname "$0")"
helmfile -e dev template | grep -q 'replicas: 1$'
helmfile -e prod template | grep -q 'replicas: 4$'
echo "helmfile OK"
