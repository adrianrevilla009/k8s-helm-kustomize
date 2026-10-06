# helm-tests

The Orders chart in `orders/` with an extra `templates/tests/test-connection.yaml` hook, and a `verify.sh` that checks it renders.

## Goal

Show how a chart ships its own smoke test that `helm test` runs against a live release.

## Run it

```bash
./verify.sh
```

Expected: `helm lint` passes, the test template renders, and the script prints `helm-tests OK`. Not run through the script in my session (the shell asked for approval); I rendered the hook by hand with `helm template demo orders --show-only templates/tests/test-connection.yaml` and got the Pod described below.

Not run end to end: `helm test` itself needs a cluster with the release installed, which this lab never creates. Only the rendering is checked.

## What it proves

- The rendered Pod `demo-orders-test` carries the annotation `"helm.sh/hook": test`, so `helm install` skips it and `helm test demo` runs it.
- It runs `wget -qO- http://demo-orders:80/actuator/health` inside `busybox:1.36.1`; the host and port come from the release name and `service.port`.
- `restartPolicy: Never` and `hook-delete-policy: hook-succeeded` make the Pod run once and be removed on success.

## Trade-offs

- The test only proves the Service answers on `/actuator/health`; it does not check Orders behaviour.
- A failing test leaves the Pod behind for inspection, which is useful but needs manual cleanup.
- The test image is pulled at test time, so air-gapped clusters need it mirrored.

## When not to use it

- For logic that a unit or integration test already covers in CI before the chart is packaged.
- When the cluster cannot create extra Pods in the release namespace.
