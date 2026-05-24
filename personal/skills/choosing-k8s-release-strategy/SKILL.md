---
name: choosing-k8s-release-strategy
description: "Picks the right Kubernetes Deployment update strategy (RollingUpdate / Recreate / Blue-Green / Canary) for the situation. Use when configuring a new Deployment, changing rollout config, or deciding how to ship a risky change."
when_to_use: "deployment strategy, rolling update, blue green, canary, maxUnavailable, maxSurge, recreate, zero downtime, k8s rollout, kubectl rollout, release strategy, how to deploy"
---

# Choosing a Kubernetes Release Strategy

## Decision Table

| Strategy | Downtime | Risk | Traffic split | Cost | When to use |
|----------|----------|------|---------------|------|-------------|
| **RollingUpdate** | None | Medium | No | 1× | Default. Stateless services, tolerant of mixed versions |
| **Recreate** | Yes | Low | No | 1× | Single-replica dev/paper envs, DB migrations requiring schema lock |
| **Blue/Green** | None | Low | Hard cutover | 2× | Need instant rollback, strict "no mixed versions" requirement |
| **Canary** | None | Very low | % of traffic | 1–2× | High-stakes change, want real traffic validation before full rollout |

## Quick Flowchart

```
Can you tolerate ~30s downtime?
  YES → Recreate (simplest, safe for single-replica staging)
  NO  → continue ↓

Does schema/protocol change break old + new pods running together?
  YES → Blue/Green (full cutover, instant rollback)
  NO  → continue ↓

Is this a high-risk change needing real-traffic validation?
  YES → Canary (shift 10% → watch → 100%)
  NO  → RollingUpdate (default, maxUnavailable: 0 / maxSurge: 1)
```

## RollingUpdate (recommended default)

```yaml
spec:
  minReadySeconds: 10          # pod must be healthy for 10s before next step
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0        # never take a pod down before a replacement is ready
      maxSurge: 1              # spin up 1 extra pod during rollout
```

**`maxUnavailable: 0` + `maxSurge: 1`** = zero-downtime: new pod comes up and passes readiness, then old pod is terminated.  
**`minReadySeconds`** adds a stability buffer — catches fast crashes that pass the readiness probe briefly.

## Recreate

```yaml
spec:
  strategy:
    type: Recreate
```

Kills all old pods, then starts new ones. Use only when:
- Single replica AND downtime is acceptable (dev, paper-trading)
- New version is incompatible with old (e.g., exclusive DB lock migration)

## Blue/Green (manual, via two Deployments)

Not a native k8s strategy — implement via two Deployments + Service selector swap:

```bash
# After green is healthy:
kubectl patch service my-svc -p '{"spec":{"selector":{"version":"green"}}}'
# Instant rollback:
kubectl patch service my-svc -p '{"spec":{"selector":{"version":"blue"}}}'
```

Costs 2× compute while both stacks run. Worth it when instant rollback is a hard requirement.

## Canary (manual, via weight split)

Run two Deployments with different replica counts to split traffic by ratio:

```yaml
# canary-deployment.yaml — 1 of 11 pods = ~9% traffic
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-svc          # same label as stable, same Service selects both
      track: canary
```

Watch error rate / latency for canary pods, then scale up or delete.  
Native traffic-% split requires a service mesh (Istio, Linkerd) or ingress annotation.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| `maxUnavailable: 1` with single replica | One pod means full downtime during rollout; set `maxSurge: 1, maxUnavailable: 0` |
| No `minReadySeconds` | Fast-crashing pods look healthy for a second; add `minReadySeconds: 10` |
| Blue/Green without resource headroom | 2× pods require 2× node capacity; check HPA limits before cutover |
| Canary using same Deployment | Use a separate Deployment so you can delete canary without touching stable |

## Verify a Rollout

```bash
kubectl rollout status deployment/my-deployment
kubectl rollout history deployment/my-deployment
kubectl rollout undo deployment/my-deployment   # instant rollback
```
