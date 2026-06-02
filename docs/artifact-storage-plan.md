# Cloud Artifact Storage Plan

This plan defines what Dioscuri-Cloud may store in cloud artifact buckets or checked-in run records. It is intentionally provider-neutral so later implementation issues can map it to S3, Azure Blob, IBM COS, Oracle Object Storage, DigitalOcean Spaces, GCS, or another approved backend.

## Artifact Categories

| Category | Examples | Storage Boundary | Retention Guidance |
|---|---|---|---|
| Run manifests | `run_manifest.json`, `summary.json`, queue summaries. | May be checked into repo when small and public-safe. | Keep indefinitely if tied to a PR or issue. |
| Experiment reports | Markdown closeouts, evaluation summaries, cost notes. | Check into `experiments/` when public-safe. | Keep indefinitely as portfolio/reproducibility records. |
| Telemetry samples | Small CSV/JSON samples, derived non-sensitive metrics. | Store in object storage if large; check in only tiny examples. | Keep until superseded; document retention in run record. |
| Generated plots | PNG/SVG/HTML reports from downstream tools. | Prefer object storage or release artifacts; check in only curated small images if needed. | Keep curated outputs; expire intermediate outputs. |
| Model downloads | GGUF/safetensors/checkpoint files. | Do not commit. Store only in approved external artifact storage with license checks. | Delete after run unless separately approved. |
| Terraform/local state | `.terraform/`, `*.tfstate`, provider caches. | Never commit; do not store in public artifact buckets. | Delete local copies after use; use HCP/remote state when appropriate. |
| Secrets and account data | API keys, tokens, token prefixes, private billing IDs. | Never commit and never place in shared artifact storage. | Rotate/revoke instead of archiving. |

## Naming Convention

Use predictable paths so downstream tools can ingest artifacts without provider-specific logic:

```text
<provider>/<YYYY-MM-DD>/<experiment-slug>/
  manifests/
  reports/
  telemetry/
  logs/
```

For checked-in experiment summaries, mirror the provider and date in `experiments/<provider>/`.

## Required Metadata

Every artifact-backed run should include:

- Git commit SHA.
- GitHub issue or PR reference.
- Provider and region.
- `saaq_version`.
- `model_slug`.
- `telemetry_source`.
- `start_time_utc` and `end_time_utc`.
- Runtime cap and cost cap.
- Actual cost when available.
- Artifact root URI or repo-relative path.
- Teardown status.
- License/provenance notes for any model or dataset reference.

## Provider Mapping

| Provider | Candidate Storage | Notes |
|---|---|---|
| AWS | S3 | Best fit for certification-aligned artifact storage labs. |
| Azure | Blob Storage | Use resource groups and same-day teardown for short labs. |
| IBM Cloud | Cloud Object Storage | Good fit for watsonx and research-agent outputs. |
| Oracle Cloud | Object Storage | Good fit for persistent telemetry/RAG service artifacts. |
| DigitalOcean | Spaces | Simple small-object smoke-test target. |
| GCP | Cloud Storage | Use only under strict monthly credit caps. |
| Vultr | Checked closeout summaries only | Inactive for near-term execution; do not upload/configure Vultr API keys unless a future issue reactivates provider use. |

## Implementation Guardrails

- Do not create storage resources without a `cost-ledger.md` estimate and teardown plan.
- Do not upload secrets, local absolute paths, model weights, or private account screenshots.
- Large generated artifacts should live outside git and be referenced by a public-safe URI or manifest.
