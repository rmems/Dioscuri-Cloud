# DigitalOcean GPU Smoke-Test Runbook

This runbook describes how to prepare, execute, and tear down a minimal DigitalOcean cloud smoke test for `Dioscuri-Cloud`.

This document is public-repo safe:
- no secrets committed
- no API tokens committed
- no machine-specific credentials committed

Use this only after the generic readiness gate is satisfied:
- `docs/runbooks/gpu-smoke-test-readiness.md`

## Scope

This runbook is for a minimal GPU smoke test only.

It is not for:
- benchmarking sweeps
- long-running model experiments
- cross-provider comparisons
- managed ML platform evaluation

If the intended work exceeds a smoke test, open a dedicated experiment issue first.

## Prerequisites

1. Readiness complete
- Finish `docs/runbooks/gpu-smoke-test-readiness.md`.
- Confirm local baseline and no-GPU object-storage smoke test are already complete.

2. DigitalOcean account + billing
- Confirm the account is active.
- Confirm the account can provision the selected droplet/GPU SKU in the selected region.

3. Authentication
- Use a DigitalOcean API token via environment variable or HCP Terraform workspace variable.
- Do not commit the token.

Examples:
- shell env: `DIGITALOCEAN_TOKEN`
- HCP Terraform sensitive variable: `DIGITALOCEAN_TOKEN`

4. Artifact destination decided
- Choose the bucket/prefix before launch.
- Use the append-only path pattern from the no-GPU smoke test:
  - `dioscuri-cloud/smoke-tests/do/<YYYY-MM-DD>/<run_id>/`

5. Cost + runtime caps defined
- Record estimated cost in `cost-ledger.md`.
- Define a maximum runtime and stop the run if it exceeds the cap.

## Suggested Minimal Smoke-Test Shape

Choose the smallest viable GPU path that proves the cloud setup works.

Success criteria:
- create the GPU droplet
- connect successfully
- run one minimal checkpoint/inference/setup path
- write or upload expected artifacts
- capture manifest metadata
- destroy the droplet

Avoid:
- multiple droplet launches
- repeated sweeps
- large datasets
- broad prompt sets
- retaining the instance after the smoke goal is met

## Setup

### 1. Select region and SKU

Document all of the following in the issue/PR before launch:
- provider: `do`
- region
- droplet size / GPU SKU
- estimated runtime
- cost cap

### 2. Confirm Terraform plan or manual provisioning path

Preferred:
- use Terraform/HCP Terraform if the DigitalOcean path is already represented there

If Terraform is not yet implemented for the exact DO smoke path:
- document the manual console/API steps in the issue
- keep scope minimal and reversible

### 3. Prepare manifest metadata

Before starting, pre-fill what you already know from:
- `docs/schemas/experiment-manifest.md`

At minimum know in advance:
- `run_id`
- `git_commit_sha`
- `repo`
- `provider` = `do`
- `region`
- `instance_type`
- `gpu_type`
- `artifact_uris` target prefix

## Execution

1. Launch the smallest suitable DigitalOcean GPU droplet.
2. Record the exact region, SKU, and start timestamp.
3. Run the minimal smoke path only:
   - checkpoint load, or
   - one-shot inference, or
   - artifact generation + upload verification
4. Upload/store artifacts in the selected prefix.
5. Record:
   - start/end time
   - estimated cost
   - actual cost if available immediately
   - artifact URIs
   - whether teardown completed successfully

## Artifact Expectations

Minimum expected outputs should include whichever are relevant for the smoke path:
- command log or terminal transcript excerpt
- generated artifact(s)
- experiment manifest JSON based on `docs/schemas/experiment-manifest.md`
- optional provider console screenshot or run note

If no model output is produced, the run should still leave enough evidence to prove:
- infra came up
- command path executed
- artifacts could be written or uploaded

## Cost Notes

DigitalOcean GPU time can become expensive quickly if the droplet is left running.

Rules:
- keep the runtime as short as possible
- destroy the droplet immediately after the smoke goal is complete
- update `cost-ledger.md` with:
  - provider = `do`
  - purpose = smoke test
  - estimated cost
  - actual cost if known
  - teardown evidence link

## Teardown

Use `docs/runbooks/teardown-checklist.md` as the required evidence checklist.

Minimum DO-specific teardown expectations:
- destroy the GPU droplet
- confirm no extra volumes remain attached/unattached
- confirm no reserved/public IPs remain allocated unintentionally
- revoke/remove temporary credentials if created
- confirm only intended object-storage artifacts remain

Acceptable teardown evidence:
- DigitalOcean console screenshot showing the droplet is gone
- CLI/API output confirming deletion
- Terraform destroy output or HCP run link

## Post-Run Record

Before closing the smoke test:
- update `cost-ledger.md`
- attach or link the experiment manifest
- attach teardown evidence
- note anything intentionally retained and its expected ongoing cost
