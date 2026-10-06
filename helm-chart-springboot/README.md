# helm-chart-springboot

A minimal Helm chart in `orders/` for the Orders Spring Boot service: a Deployment, a Service and a `values.yaml`.

## Goal

Show the smallest chart that is still realistic for a Spring Boot app: probes on the Actuator endpoints, configuration injected from values, and consistent labels and selectors.

## Run it

```bash
helm lint orders && helm template demo orders
```

Expected: lint ends with `1 chart(s) linted, 0 chart(s) failed` (plus an `icon is recommended` info line), and the render prints a Service and a Deployment named `demo-orders`. This folder has no `verify.sh`; I ran `helm lint` and it gave exactly that result.

## What it proves

- `templates/deployment.yaml` builds the image from `image.repository` and `image.tag`, and builds one `env` entry per key in the `env` map of `values.yaml`.
- Readiness and liveness probes point at `/actuator/health/readiness` and `/actuator/health/liveness` on the named port `http`, and the Service targets that same port name.
- The selector labels `app.kubernetes.io/name` and `app.kubernetes.io/instance` match between the Deployment, its Pod template and the Service.

## Trade-offs

- There is no `_helpers.tpl`, Ingress, HPA or ServiceAccount, which keeps the templates short but repeats the label block.
- Resource names come from `.Release.Name`, so two releases in one namespace do not collide, but names get long.
- Nothing is installed on a cluster. Rendering is checked, scheduling and probes are not.

## When not to use it

- When you only deploy to one environment and plain manifests, perhaps with Kustomize, are enough.
- When many near-identical services need the same template; a shared library chart avoids copying this one.
