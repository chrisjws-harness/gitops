# GitOps Starter Repo (podinfo)

A ready-to-use GitOps source repository for the Harness GitOps walkthrough.
**Copy the contents of this directory into your own Git repo** (e.g. a new GitHub
repo) - this becomes the source of truth that Harness GitOps / Argo CD syncs from.

The same sample app ([podinfo](https://github.com/stefanprodan/podinfo)) is
provided in **three rendering styles**, because teams here use Helm, Kustomize,
or both. Pick whichever matches the team you are demoing to - or wire up several
GitOps Applications to show all of them side by side.

## Layout

```
.
├── kustomize/podinfo/          # Plain Kustomize: base + per-env overlays
│   ├── base/
│   └── overlays/{dev,staging,prod}/
├── helm/podinfo/               # Helm chart + per-env values files
│   ├── Chart.yaml
│   ├── values.yaml             # defaults
│   ├── values-{dev,staging,prod}.yaml
│   └── templates/
└── kustomize-helm/podinfo/     # Combined: Kustomize inflates a Helm chart
    └── kustomization.yaml
```

## The three approaches, and how to point a GitOps Application at each

| Approach | Application source path | Extra config | Notes |
|----------|------------------------|--------------|-------|
| **Kustomize** | `kustomize/podinfo/overlays/dev` (or `staging`/`prod`) | none | Argo auto-detects `kustomization.yaml` |
| **Helm** | `helm/podinfo` | Values files: `values-dev.yaml` (or staging/prod) | Argo auto-detects `Chart.yaml` |
| **Kustomize + Helm** | `kustomize-helm/podinfo` | Enable the `--enable-helm` kustomize build option | Inflates the upstream podinfo chart, then patches via Kustomize |

In all three, the **image tag is the artifact version** (dev `6.7.1` ->
staging `6.7.0` -> prod `6.6.0`). Promoting between environments = bumping that
tag (overlay `newTag`, or Helm `image.tag` in the next values file) via a PR.

## Render locally before wiring up GitOps

```bash
# Kustomize
kubectl kustomize kustomize/podinfo/overlays/dev

# Helm
helm template podinfo-dev helm/podinfo -f helm/podinfo/values-dev.yaml -n demo-dev

# Kustomize + Helm (needs network to pull the chart)
kubectl kustomize --enable-helm kustomize-helm/podinfo
```

## Target namespaces

The Kustomize overlays deploy into `demo-dev` / `demo-staging` / `demo-prod`.
For Helm, pass the namespace on the GitOps Application destination (or `-n` when
rendering locally). Create the namespace before the first sync if it does not
auto-create.
