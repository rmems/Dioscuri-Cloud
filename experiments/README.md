# Experiments

This directory stores experiment reports by dated folder and provider context. Reports should be reproducible, evidence-based, and limited to smoke-test or cost-controlled workflows.

## Required fields for every experiment
- `run_id`
- `git_sha`
- `model_slug`
- `provider`
- `region`
- `gpu_type`
- `instance_type`
- `saaq_version`
- `telemetry_source`
- `heartbeat_enabled`
- `runtime_seconds`
- `estimated_cost_usd`
- `artifacts`
- `teardown_confirmed`
- `result summary`
- `failure notes`

## Data integrity rule
Do **not** add fake results. If a run did not happen, mark fields as `TBD` and describe planned steps only.