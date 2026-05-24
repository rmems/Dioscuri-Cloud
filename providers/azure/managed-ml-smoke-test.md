# Azure Managed ML Smoke-Test Runbook

This runbook documents a minimal Azure managed-ML smoke test for `Dioscuri-Cloud`.

This is a smoke test only:
- shortest viable runtime
- smallest viable managed-ML resource footprint
- enough output to prove the path works
- full teardown required afterward

This document is public-repo safe:
- no Azure credentials committed
- no secrets committed
- no subscription-specific secrets committed

## Scope

Primary target:
- Azure ML managed online/batch inference or a minimal Azure ML training path

Do not use this runbook for:
- benchmarking sweeps
- dataset-scale experiments
- productionized serving
- long-lived compute clusters or endpoints

## Required Supporting Docs

- `docs/runbooks/gpu-smoke-test-readiness.md`
- `docs/runbooks/teardown-checklist.md`
- `docs/schemas/experiment-manifest.md`
- `cost-ledger.md`

## Prerequisites

1. Readiness complete
- Finish the generic GPU smoke-test readiness checklist.

2. Azure subscription and region chosen
- Select the exact Azure region before launch.
- Confirm Azure ML and the planned compute SKU are available in that region.

3. Authentication path prepared
- Use `az login`, workload identity, or HCP Terraform workspace variables.
- Do not commit credentials.

Examples:
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`

4. Artifact destination chosen
- Preselect blob/object storage for run artifacts.
- Use append-only layout:
  - `dioscuri-cloud/smoke-tests/azure/<YYYY-MM-DD>/<run_id>/`

5. Cost and teardown plan recorded
- Add or prepare the `cost-ledger.md` row before provisioning.
- Define max runtime and max cost cap before launch.

## Recommended Minimal Azure Smoke-Test Shape

Choose the smallest managed-ML path that proves the Azure route is alive.

Good smoke-test examples:
- create the minimal Azure ML job or endpoint
- run one known-good inference or tiny test job
- emit one result artifact bundle
- tear down all active compute/endpoints immediately

Success criteria:
- Azure ML job or endpoint starts successfully
- one inference or tiny job completes
- expected artifacts/metadata are captured
- teardown evidence is collected

## Pre-Launch Metadata

Before starting, pre-fill the manifest fields you already know:
- `run_id`
- `git_commit_sha`
- `repo`
- `model_slug`
- `saaq_version`
- `telemetry_source`
- `provider` = `azure`
- `region`
- `instance_type`
- `gpu_type`
- `artifact_uris` target prefix

## Execution

1. Record `start_time_utc`.
2. Launch the smallest viable Azure ML managed path.
3. Execute one minimal smoke action only:
   - one known-good inference request, or
   - one tiny Azure ML job
4. Capture outputs:
   - workspace/job/endpoint identifiers
   - command/request payload summary
   - result artifact(s)
   - console or CLI confirmation
5. Record `end_time_utc`, estimated cost, and actual cost if already visible.

## Captured Output Expectations

Minimum captured outputs:
- workspace/job/endpoint identifier
- region and instance type
- smoke-test result or success marker
- experiment manifest JSON
- one console screenshot, CLI output snippet, or service log link

## Cost Notes

Azure ML managed compute and endpoints can continue billing if not deleted promptly.

Rules:
- use the smallest viable compute
- avoid leaving endpoints or compute instances running after validation
- record provider = `azure` in `cost-ledger.md`

## Teardown

Use `docs/runbooks/teardown-checklist.md` as the required teardown evidence source.

Azure-specific minimum teardown:
- delete Azure ML endpoints or active deployments created for the run
- stop/delete Azure ML jobs or compute instances/clusters if applicable
- confirm no public IPs, disks, or networking resources remain unintentionally
- confirm only intended storage artifacts remain

Acceptable evidence:
- Azure ML portal showing no active endpoint/job/compute
- Azure CLI output confirming deletion
- Terraform destroy / HCP Terraform run link if Terraform was used

## Post-Run Record

Before closing the smoke test:
- update `cost-ledger.md`
- attach or link the experiment manifest
- attach teardown evidence
- note anything intentionally retained and why
