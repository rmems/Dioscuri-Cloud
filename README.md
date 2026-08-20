# Dioscuri-Cloud

Cloud operations layer for **AI model training setup** on student/free cloud credits: object storage, CUDA images, GPU nodes, managed training jobs (SageMaker / Azure ML), cost tracking, and HCP Terraform control plane.

Training implementation code may live in other repos (e.g. `rmems/agoge-forger`); this repo owns **reproducible cloud infra, runbooks, and experiment records**.

## Goals

- Stand up bounded cloud training infrastructure (S3 checkpoints, GPU or managed training jobs).
- Keep cloud spend visible through `cost-ledger.md` and GitHub-tracked issues.
- Document provider setup, teardown, and HCP workspace boundaries before expensive jobs.
- Produce durable artifacts: runbooks, training smoke reports, cost notes, and manifest schemas.

See [`docs/training-setup.md`](docs/training-setup.md) for the current issue epic and dependency order.

## Non-goals

- No from-scratch large-scale pretraining (e.g. full Grok-1).
- No secrets, API keys, DSNs, local checkpoint paths, or model weights committed.
- No long-running GPU jobs without a cost estimate, GitHub issue, and teardown plan.

Bounded fine-tune / SFT / tiny training smokes **are** in scope when authorized by a `[TRAIN]` issue.

## Repository layout

```text
providers/                 Provider-specific runbooks
terraform/                 Terraform/HCP notes and module layout
infra/terraform/           Environment-specific Terraform scaffolds
experiments/               Experiment reports and run records
docs/                      Cross-provider documentation and schemas
cost-ledger.md             Running estimate of cloud credit usage
```

See `docs/repository-structure.md` for the lab skeleton and file ownership conventions.

## Provider strategy (training)

| Provider | Primary role |
|---|---|
| AWS | **Primary** — S3 artifacts, GPU instances, SageMaker training jobs |
| Azure | **Backup** — Azure ML training jobs, Blob artifacts |
| DigitalOcean | Optional GPU availability / small nodes |
| GCP / Vertex AI | Metadata-only / tiny planning under monthly cap |
| HashiCorp | HCP Terraform control plane (not GPU compute) |
| IBM Cloud / Oracle / Vultr | Expired trial or closeout — **not** the active training path |

See `docs/cloud-credit-strategy.md`, `docs/credits/inventory.md`, and `docs/provider-comparison.md`.

## Run discipline

Every cloud training run should include:

- Git commit SHA
- GitHub issue reference
- `base_model` / trainer / steps (for training jobs)
- provider and region
- GPU or instance type
- start/end time
- estimated and actual cost
- artifact URIs (`docs/training/artifact-layout.md`)
- teardown confirmation

Start with documentation and bounded smokes. Scale only after a reproducible tiny job succeeds.
