# helmfile

A `helmfile.yaml` with `dev` and `prod` environments that deploys the local Orders chart in `orders/`, plus `env/dev.yaml` and `env/prod.yaml`.

## Goal

Show how Helmfile declares releases and environments in one file, so a single command renders or applies every environment consistently.

## Run it

```bash
./verify.sh
```

Expected: the script runs `helmfile -e dev template` and `helmfile -e prod template`, checks for `replicas: 1` and `replicas: 4`, and prints `helmfile OK`.

Not run: the `helmfile` binary is not installed on this machine, so neither the script nor the Helmfile has been executed. The chart itself renders with Helm, but the Helmfile templating is unchecked.

## What it proves

- `helmfile.yaml` defines environments `dev` and `prod`, each loading its values from `env/dev.yaml` or `env/prod.yaml`.
- The release `orders` takes its namespace (`orders-dev` or `orders-prod`) and `SPRING_PROFILES_ACTIVE` from the environment name.
- The replica count comes from `.Environment.Values.replicas` in the env file, and the chart version is pinned to `0.1.0`.

## Trade-offs

- Helmfile is a separate binary on top of Helm, and the Go templating in the YAML is harder to read and debug.
- The release list is short here; the benefit grows with many releases and shared settings.
- `env/dev.yaml` and `env/prod.yaml` only hold a replica count, so the rest of the environment logic sits in `helmfile.yaml`.

## When not to use it

- When you deploy one chart to one environment; `helm upgrade --install` is enough.
- When the team already uses GitOps tools such as Argo CD or Flux that own the release list.
