#!/usr/bin/env bash
# Static check: the test hook renders. Running `helm test` itself needs a cluster (see README).
set -euo pipefail
cd "$(dirname "$0")"
helm lint orders >/dev/null
out=$(helm template demo orders --show-only templates/tests/test-connection.yaml)
grep -q 'helm.sh/hook": test' <<<"$out"
grep -q 'http://demo-orders:80/actuator/health' <<<"$out"
echo "helm-tests OK"
