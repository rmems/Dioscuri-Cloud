# Vultr GPU/Inference Go/No-Go

Goal: decide whether Vultr has an available, affordable, and safe GPU or inference target for a minimal smoke test before `2026-05-28`.

This checkpoint must happen before any GPU/inference resource is created.

## Guardrails

- Do not create GPU or inference resources in this step unless an availability check is explicitly non-billable and required.
- Default Vultr cap remains `$25` per experiment unless separately approved.
- Same-day teardown is required for any created resource.
- Do not commit credentials, API keys, private billing details, raw account output, local state, or generated artifacts.

## Candidate Checks

Record exact commands used and redact account-sensitive output.

```bash
vultr-cli regions list
vultr-cli plans list
vultr-cli plans list --type vcg
vultr-cli plans list --type vhf
```

If the CLI version does not support these filters, use equivalent API or console checks and document the replacement path.

## Decision Inputs

Record:
- candidate regions
- candidate SKU/plan IDs
- GPU type or inference target type
- hourly price
- storage/network cost assumptions
- estimated maximum runtime
- quota/stock/access status
- selected artifact region or storage path
- fallback path if no-go

## Decision Output

Copy `decision-template.md` to a dated decision file only after the real check is complete.

Allowed outcomes:
- `go`: selected target, runtime cap, cost cap, and teardown path are documented
- `no-go`: blocker and fallback path are documented
- `blocked`: access/tooling issue prevents a reliable decision

## Dependencies

- Bootstrap: `providers/vultr/bootstrap.md`
- Terraform scaffold: `infra/terraform/environments/vultr-dev/README.md`
- No-GPU preflight: `experiments/vultr/no-gpu-preflight/README.md`
- GPU readiness checklist: `docs/runbooks/gpu-smoke-test-readiness.md`
- Cost ledger: `cost-ledger.md`
