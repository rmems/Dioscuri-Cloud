# Vultr No-GPU Preflight

Goal: verify Vultr account/API access, region/plan visibility, Terraform scaffold health, and public-safe run-record discipline without creating GPU or inference resources.

Default target: `$0` API-only preflight.

Hard cap: `$5` unless separately approved.

## Guardrails

- Do not create GPU instances or inference endpoints.
- Do not create reserved IPs, long-lived object storage, or persistent infrastructure.
- Do not commit `VULTR_API_KEY`, provider credentials, local state, private telemetry, raw account output, or generated artifacts.
- If any resource is created by exception, tear it down same day and record evidence.

## Inputs

- `VULTR_API_KEY` available in the execution environment.
- Terraform scaffold in `infra/terraform/environments/vultr-dev/` validates locally.
- Credit deadline and spend cap reviewed in `docs/credits/inventory.md`.

## Commands To Record

Run the commands that are available for the installed Vultr CLI version. Redact account-specific fields before committing a record.

```bash
vultr-cli account info
vultr-cli regions list
vultr-cli plans list
terraform -chdir=infra/terraform/environments/vultr-dev init -backend=false
terraform -chdir=infra/terraform/environments/vultr-dev validate
```

## Run Record

Copy `run-record-template.md` to a dated file only after an actual preflight is run.

Required result fields:
- run id
- provider: `vultr`
- date/time
- git commit SHA
- commands run
- target region or blocker
- estimated cost
- actual cost or reconciliation path
- teardown evidence or `N/A API-only preflight`

## Cost Ledger

If the actual API-only preflight is run, add a Vultr row to `cost-ledger.md` with:
- estimated cost: `0`
- actual cost: `0` if visible, otherwise `TBD`
- teardown evidence: `N/A API-only preflight` if no resources were created

Do not add a fake ledger row for templates or blocked runs.

## Artifact Path Discipline

If a later no-GPU storage upload is approved, use an append-only prefix:

```text
dioscuri-cloud/smoke-tests/vultr/<YYYY-MM-DD>/<run_id>/
```

The shared no-GPU pattern lives in `experiments/no-gpu-object-storage-smoke/README.md`.

## Related Docs

- Bootstrap: `providers/vultr/bootstrap.md`
- Terraform scaffold: `infra/terraform/environments/vultr-dev/README.md`
- Cost ledger: `cost-ledger.md`
- Teardown checklist: `docs/runbooks/teardown-checklist.md`
