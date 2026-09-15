# Dioscuri-Cloud

Cloud operations layer for **AI model training setup** on student/free cloud credits: object storage, CUDA images, GPU nodes, managed training jobs (SageMaker / Azure ML), cost tracking, and HCP Terraform control plane.

Training implementation lives in [`rmems/agoge-forger`](https://github.com/rmems/agoge-forger); this repo orchestrates it in the cloud.

## Repo boundary

| Side | Owns |
|---|---|
| Agoge ([`rmems/agoge-forger`](https://github.com/rmems/agoge-forger)) | Train/eval, checkpoints, manifests, HF release tooling |
| Dioscuri (this repo) | Terraform, cloud jobs, costs, provider runbooks, training image, S3, SageMaker/bootstrap, cost ledger |
| Upstream data | [`synthetic-factory`](https://github.com/rmems/synthetic-factory) / [`operation-prometheus`](https://github.com/rmems/operation-prometheus) |

No cloud-infra trees in Agoge.

Agoge trainer today: Typer CLI `agoge` → `agoge_forger.cli:app`. Primary path is TRL SFTTrainer + PEFT + bitsandbytes QLoRA via `uv run agoge train-qlora --config <yaml>` (also `train-lora`). Makefile: `setup`, `check-torch`, `train-smoke` (MiniCPM5 canary), `eval-smoke` (toy), `test`, `lint`. Stock configs: `configs/minicpm5_canary.yaml`, `configs/granite_4_1_flagship.yaml`, `configs/minicpm5_code_repair.yaml.example`. Local RTX 5080 notes: Agoge `docs/rtx5080_local_training.md`. Artifacts: `adapters/<run_name>`, `checkpoint-*`, `merged/<run_name>`.

Local smoke exists; the cloud path is infra-first here. Do not claim ready: stock YAMLs may not pin revision; `make eval-smoke` is toy; no Trackio or fail-closed cost caps in Agoge (Dioscuri owns cost discipline if claimed); factory export ingest is not in Agoge; Hub push is not a current ladder rung. Open Agoge issues exist for qualify/harness/Granite — do not invent readiness numbers.

Operators launching from the cloud side typically run in Agoge (not this repo):

```text
uv sync --all-groups
uv run agoge check-torch
uv run agoge train-qlora --config configs/minicpm5_canary.yaml
uv run agoge export-final-model --run-dir adapters/<run_name> --out-dir merged/<run_name>
```

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

Every cloud training run should include the fields in `docs/schemas/experiment-manifest.md`:

- Git commit SHA and GitHub issue (`github_issue`, required for billable runs)
- `job_type=training`, `base_model` (same as `model_slug` unless an adapter slug is used), `trainer`
- `steps_configured` and `steps_completed` (not a single ambiguous `steps` field)
- `telemetry_source` (`synthetic`, `sft`, or `dataset` — not a fake `saaq_version`)
- provider, region, GPU or instance type
- start/end time, estimated and actual cost
- artifact URIs (`docs/training/artifact-layout.md`)
- teardown confirmation

Start with documentation and bounded smokes. Scale only after a reproducible tiny job succeeds.
