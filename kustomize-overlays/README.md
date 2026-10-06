# kustomize-overlays

Plain Deployment and Service manifests in `base/`, with `overlays/dev` and `overlays/prod` that change them without templating.

## Goal

Show the Kustomize approach to environments: keep one readable base and let each overlay set the namespace, name prefix, replica count, image tag and patches.

## Run it

```bash
./verify.sh
```

Expected: the script builds both overlays with `kubectl kustomize`, checks the output with `grep`, and prints `kustomize-overlays OK`.

Not run: in my session `kubectl kustomize` was not allowed to execute, so neither the script nor the overlays have been built here. The assertions are written from reading the overlay files, not from observed output.

## What it proves

- `overlays/dev` uses namespace `orders-dev`, prefix `dev-`, 1 replica, image tag `1.0.0-SNAPSHOT` and a JSON patch setting the profile to `dev`.
- `overlays/prod` uses namespace `orders-prod`, prefix `prod-`, 4 replicas, profile `prod`, and adds requests (500m, 512Mi) and a 1Gi memory limit through a patch.
- `base/` stays valid on its own with 2 replicas and tag `1.0.0`; the overlays reference it as `../../base`.

## Trade-offs

- JSON patches address env entries by index (`env/0/value`), so reordering the base env silently patches the wrong item.
- No templating means no loops or conditionals; large differences become many patches.
- The base has no resource limits, so any overlay that forgets them runs unbounded.

## When not to use it

- When you need packaging, versioning and `helm test` for consumers outside your team; a chart fits better.
- When environments differ in many values; a values file is shorter than many patches.
