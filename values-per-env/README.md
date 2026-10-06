# values-per-env

The Orders chart in `orders/` plus two override files, `values-dev.yaml` and `values-prod.yaml`, and a `verify.sh` that renders both.

## Goal

Show how one chart serves several environments by layering a small values file over the chart defaults, instead of copying templates.

## Run it

```bash
./verify.sh
```

Expected: the script renders the chart twice with `helm template`, checks the output with `grep`, and prints `values-per-env OK`. Not run through the script in my session (the shell asked for approval); I rendered the prod case by hand with `helm template orders orders -f values-prod.yaml` and it showed `replicas: 4`, `SPRING_PROFILES_ACTIVE` `"prod"` and a `1Gi` memory limit.

## What it proves

- `values-dev.yaml` gives 1 replica, image tag `1.0.0-SNAPSHOT`, `pullPolicy: Always`, profile `dev` and `LOGGING_LEVEL_ROOT: DEBUG`.
- `values-prod.yaml` gives 4 replicas, tag `1.0.0`, profile `prod`, `LOGGING_LEVEL_ROOT: WARN` and requests of 500m CPU and 512Mi memory with a 1Gi limit.
- Each override file only lists what differs; everything else, such as the repository and probes, comes from `orders/values.yaml`.

## Trade-offs

- Maps are merged but lists are replaced, so overriding part of a list means repeating all of it.
- The environment files are not validated against a schema, so a typo like `replicacount` renders silently with the default.
- Environment is chosen by the `-f` flag; nothing stops you applying the dev file to a prod cluster.

## When not to use it

- When the environments differ in structure (extra resources, different kinds), not just in values; overlays or separate charts fit better.
- When you want the environment list and versions declared in one place; see `helmfile`.
