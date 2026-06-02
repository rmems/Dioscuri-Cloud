# Vultr 2026-05-28 Bounded Quantization Queue

GitHub issue: `rmems/Dioscuri-Cloud#43`

Status: `closed-window-summary`

This queue records the bounded run plan for the Vultr credit sprint. It does not claim GPU/SAAQ execution in this repository. The credit window closed with a serverless inference pivot documented in `experiments/vultr/2026-05-27-serverless-inference-credit-sprint.md`. Vultr is inactive for near-term execution, and this update does not upload/configure Vultr API access.

## Queue Fields

| Field | Description |
|---|---|
| `queue_id` | Stable queue item ID. |
| `model_family` | Candidate model family or prerequisite gate. |
| `source_repo` | Owning repo for runtime implementation or gate. |
| `run_matrix_ref` | Source run matrix, issue, or gate reference. |
| `model_path_or_download_ref` | Approved download/staging reference; never a local secret path. |
| `cloud_region` | Target Vultr region, or `provider-selected` for serverless. |
| `instance_or_endpoint_type` | GPU instance, serverless endpoint, or `api-only`. |
| `max_runtime_minutes` | Hard runtime cap. |
| `max_cost_usd` | Hard cost cap. |
| `expected_output_root` | Repo-relative or external artifact root. |
| `status` | `queued`, `running`, `succeeded`, `failed`, or `skipped`. |
| `skip_reason` | Stable reason when skipped. |
| `teardown_status` | Teardown or non-resource status. |
| `cost_ledger_ref` | `cost-ledger.md` row or follow-up reference. |

## Queue

| queue_id | model_family | source_repo | run_matrix_ref | model_path_or_download_ref | cloud_region | instance_or_endpoint_type | max_runtime_minutes | max_cost_usd | expected_output_root | status | skip_reason | teardown_status | cost_ledger_ref |
|---|---|---|---|---|---|---|---:|---:|---|---|---|---|---|
| `vultr-20260528-p0-api-preflight` | `provider-gate` | `rmems/Dioscuri-Cloud` | `experiments/vultr/no-gpu-preflight/` | `N/A` | `N/A` | `api-only` | 15 | 0 | `experiments/vultr/no-gpu-preflight/` | `skipped` | `prior authenticated account API checks returned HTTP 401; sprint pivoted to serverless inference records` | `no resources created by queue item` | `cost-ledger.md` Vultr rows |
| `vultr-20260528-p0-gpu-go-no-go` | `provider-gate` | `rmems/Dioscuri-Cloud` | `experiments/vultr/gpu-go-no-go/` | `N/A` | `TBD` | `gpu-capacity-check` | 20 | 0 | `experiments/vultr/gpu-go-no-go/` | `skipped` | `GPU quota/stock/access not re-approved before credit closeout` | `no resources created by queue item` | `cost-ledger.md` Vultr rows |
| `vultr-20260528-p0-minimal-smoke` | `provider-gate` | `rmems/corinth-canal` | `corinth-canal` multi-model run matrix gate | `approved small smoke candidate only` | `TBD` | `cloud-gpu-or-inference` | 30 | 10 | `experiments/vultr/gpu-smoke-test/` | `skipped` | `blocked by GPU go/no-go not passing in this repo` | `no resources created by queue item` | `cost-ledger.md` Vultr rows |
| `vultr-20260528-p1-small-moe-baseline` | `small-moe-baseline` | `rmems/corinth-canal` | `corinth-canal` bounded SAAQ run matrix | `approved small MoE candidate only` | `provider-selected` | `serverless-inference` | 60 | 75 | `experiments/vultr/2026-05-27-serverless-inference-credit-sprint.md` | `succeeded` | `N/A` | `serverless API; no repo-managed compute teardown recorded` | `cost-ledger.md` 2026-05-27 Vultr row |
| `vultr-20260528-p1-additional-small-candidates` | `small-moe-candidates` | `rmems/corinth-canal` | `corinth-canal` bounded SAAQ run matrix | `approved entries only` | `provider-selected` | `serverless-inference` | 120 | 162.31 | `experiments/vultr/2026-05-27-serverless-inference-credit-sprint.md` | `succeeded` | `N/A` | `serverless API; no repo-managed compute teardown recorded` | `cost-ledger.md` 2026-05-27 Vultr row |
| `vultr-20260528-p2-grok1-derived-path` | `grok-1-derived` | `rmems/xai-dissect`, `grok-ozempic` | `xai-dissect` and `grok-ozempic` gates | `derived artifacts only if gates pass` | `TBD` | `cloud-gpu-or-serverless` | 60 | 0 | `TBD` | `skipped` | `downstream gates and provider GPU go/no-go did not pass for full cloud execution in this repo` | `no resources created by queue item` | `N/A` |
| `vultr-20260528-p3-full-grok1` | `grok-1-full` | `rmems/xai-dissect`, `grok-ozempic`, `rmems/corinth-canal` | downstream full-model gates | `full artifacts only if explicitly approved` | `TBD` | `cloud-gpu` | 180 | 0 | `TBD` | `skipped` | `full Grok-1 was outside approved Vultr conditions and non-goals` | `no resources created by queue item` | `N/A` |

## Final Queue Summary For Surrogate_Viz.jl

| Metric | Value |
|---|---:|
| Queue items | `7` |
| Succeeded items | `2` |
| Skipped items | `5` |
| Repo-managed compute resources created | `0` |
| Reconciled Vultr spend | `$237.31` |
| Token usage | `1,604,112+` |
| Final provider recommendation | `closeout-only; not active for near-term Vultr execution` |

Downstream reporting should treat the checked-in sprint report as the public-safe summary and should not expect model weights, raw logs, private account data, or local artifact paths in this repo.
