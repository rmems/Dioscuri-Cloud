# Experiment Manifest Schema

This schema defines the provider-neutral manifest for cloud ML / SAAQ experiment runs in `Dioscuri-Cloud`.

It is intentionally human-readable first and JSON-friendly second. The goal is that a contributor can fill this out by hand, while future smoke tests and automation can also emit it directly as an artifact.

Additional source of truth:
- `README.md` run discipline in this repo
- `corinth-canal/examples/saaq_latent_calibration.rs` (`run_manifest.json`, `summary.json`)
- `corinth-canal/manifests/known_good_runs.md` (telemetry vocabulary)

## Required Fields

| Field | Type | Description |
|---|---|---|
| `run_id` | string | Unique run identifier. Prefer a directory-safe slug or timestamped ID. |
| `git_commit_sha` | string | Git commit SHA for the code used during the run. |
| `repo` | string | Repository slug, e.g. `rmems/Dioscuri-Cloud` or `rmems/corinth-canal`. |
| `model_slug` | string | Canonical model identifier used for the run. |
| `saaq_version` | string | SAAQ version/rule family used by the run, e.g. `saaq_v1_5`, `legacy_v1_0`. |
| `telemetry_source` | string | Source label for telemetry. Align with `corinth-canal` labels such as `synthetic`, `synthetic_fallback`, `csv_re4`, or `csv_<stem>`. |
| `provider` | string | Cloud provider used for the run, e.g. `aws`, `azure`, `gcp`, `ibm`, `do`, `vultr`. |
| `region` | string | Cloud region or location. |
| `instance_type` | string | Compute instance/machine type. Use `n/a` for no-compute storage-only runs. |
| `gpu_type` | string or null | GPU type if used; `null` for CPU/no-GPU runs. |
| `start_time_utc` | string | RFC 3339 UTC timestamp for run start. |
| `end_time_utc` | string | RFC 3339 UTC timestamp for run end. |
| `estimated_cost_usd` | number | Estimated total run cost in USD. |
| `actual_cost_usd` | number or null | Actual reconciled run cost in USD, or `null` until known. |
| `artifact_uris` | array of strings | URIs/paths to produced artifacts. |
| `teardown_confirmed` | boolean | Whether teardown was completed and evidenced. |
| `notes` | string | Free-form human note describing result, caveats, or retained resources. |

## Strongly Recommended Fields

These fields are not core-required for every run today, but they should be populated whenever relevant because they already exist in the research/runtime vocabulary.

| Field | Type | Description |
|---|---|---|
| `validation_status` | string | e.g. `completed`, `tick_failed`, `gpu_setup_failed`, `storage_upload_failed`. |
| `cost_ledger_ref` | string | Link or path to the `cost-ledger.md` row / PR / issue comment carrying the spend record. |
| `linear_issue` | string | Linear identifier or URL, e.g. `MET-14`. |
| `github_issue` | string | GitHub issue URL or `owner/repo#number`. |

## Optional Fields For Future SAAQ / Neighborhood Mapping Work

These fields are optional now but reserved for future experiments so the schema can grow without a rename.

| Field | Type | Description |
|---|---|---|
| `model_family` | string | Model family from `corinth-canal`, e.g. `Olmoe`, `Qwen3Moe`, `Gemma4`. |
| `checkpoint_format` | string | e.g. `gguf`, `safetensors`, `cloud-api`. |
| `routing_mode` | string | e.g. `stub_uniform`, `dense_sim`, `spiking_sim`. |
| `prompt_profile` | string | Prompt/test profile label used by the run. |
| `repeat_idx` | integer | Repeat index for repeated validation sweeps. |
| `repeat_count` | integer | Total repeat count configured for the sweep. |
| `neighborhood_id` | string | Identifier for a neighborhood or cluster of related experiments. |
| `neighborhood_label` | string | Human-readable neighborhood label. |
| `mapping_strategy` | string | Mapping strategy used for neighborhood experiments. |
| `source_dataset` | string | Dataset/corpus used to drive the run, e.g. `csv_re4`. |
| `artifact_manifest_uri` | string | URI/path to a more detailed run artifact manifest, if emitted separately. |

## Conventions

1. Time format
- Use RFC 3339 UTC timestamps, e.g. `2026-05-23T14:10:00Z`.

2. Cost format
- Use decimal USD values, not strings.
- Use `null` for `actual_cost_usd` until the number is reconciled.

3. Artifact URIs
- Use full URIs when possible (`s3://...`, `gs://...`, `https://...`).
- Repo-relative paths are acceptable for local artifacts or checked-in run reports.

4. No-GPU runs
- For storage-only or metadata-only runs, set:
  - `instance_type`: `"n/a"`
  - `gpu_type`: `null`

5. Teardown
- `teardown_confirmed` must only be `true` when teardown evidence exists or the run explicitly documents retained resources with cost notes.

## Relationship To `corinth-canal`

`corinth-canal` already emits `run_manifest.json` and `summary.json` for validation runs. This schema does not replace those runtime-specific files. Instead, it gives `Dioscuri-Cloud` a provider-neutral envelope for cloud-run metadata that can reference or embed data from those files.

Examples of direct alignment:
- `run_id`
- `model_slug`
- `telemetry_source`
- `validation_status`
- `artifact_uris`

## Example

See `docs/schemas/examples/experiment-manifest.example.json`.
