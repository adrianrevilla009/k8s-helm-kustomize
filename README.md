# k8s-helm-kustomize

Five small folders that package the same Orders Spring Boot service with Helm, Kustomize and Helmfile, so you can compare how each tool handles per-environment configuration.

## What is inside

| Folder | What it shows | Run |
| --- | --- | --- |
| [`helm-chart-springboot`](./helm-chart-springboot) | Minimal chart: Deployment with Actuator probes, env from values, Service | `helm lint orders && helm template demo orders` |
| [`values-per-env`](./values-per-env) | Same chart rendered with `values-dev.yaml` and `values-prod.yaml` | `./verify.sh` |
| [`helm-tests`](./helm-tests) | A `helm test` hook Pod that calls the health endpoint | `./verify.sh` |
| [`kustomize-overlays`](./kustomize-overlays) | Plain base manifests with `dev` and `prod` overlays | `./verify.sh` |
| [`helmfile`](./helmfile) | One Helmfile deploying the chart to `dev` and `prod` | `./verify.sh` |

## Prerequisites

- Helm 3
- kubectl (its built-in `kubectl kustomize` is used, no separate Kustomize binary)
- Helmfile, only for the `helmfile` folder
- No cluster is needed: every command renders manifests locally. The image `ghcr.io/example/orders` is never pulled.

## How to read it

Start with `helm-chart-springboot`, because the next three Helm folders reuse its chart, then compare `values-per-env` with `kustomize-overlays`, which solve the same problem differently. Each folder is standalone and has its own README.
