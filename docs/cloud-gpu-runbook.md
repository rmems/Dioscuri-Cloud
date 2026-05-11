# Cloud GPU Runbook (Generalized)

## 1) Preflight
- Define run scope (smoke-test objective only).
- Confirm model slug and run ID.
- Confirm budget estimate and teardown plan.
- Confirm secrets strategy (external secret manager, no repo leakage).

## 2) Model/source verification
- Verify official model source URL/repository.
- Record verification status in run manifest.
- If source cannot be verified, stop and mark run as blocked.

## 3) Environment setup
- Provision minimal required compute.
- Validate CUDA/driver/runtime compatibility.
- Stage runtime configs without embedding secrets.

## 4) Run command (placeholder)
```bash
# TBD: replace with provider/runtime-specific smoke command
# example placeholder only
<run_command_here> --model <model_slug> --run-id <run_id>
```

## 5) Artifact collection
- `run_manifest.json`
- `artifacts/index.csv`
- `logs/`
- `metrics/`
- `results.md`

## 6) Observability fields
Capture at least:
- run_id, git_sha, model_slug
- provider/region/gpu_type
- saaq_version
- telemetry_source
- heartbeat_enabled
- runtime_seconds
- estimated_cost_usd
- success/error_category

## 7) Teardown
- Stop and delete compute/storage resources.
- Confirm no active billable resources remain.
- Record teardown confirmation in experiment report and cost ledger.

## 8) Failure taxonomy
- Capacity unavailable
- Runtime/CUDA mismatch
- OOM/VRAM insufficiency
- Artifact persistence failure
- Telemetry/reporting gap
