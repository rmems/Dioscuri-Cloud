# saaq-cloud-ml-lab

Cloud ML infrastructure lab for SAAQ experiments, MoE model smoke tests, cost tracking, and provider-specific runbooks.

This repo is not the core SAAQ implementation. The core implementation lives in `rmems/corinth-canal`. This repo is the cloud operations layer used to document reproducible experiments across free/student cloud credits.

## Goals

- Run small, controlled SAAQ smoke tests on cloud GPUs.
- Keep cloud spend visible through a cost ledger.
- Document provider setup and teardown steps before running expensive jobs.
- Store cloud/MLOps runbooks for DigitalOcean, AWS, Azure, GCP/Vertex AI, Vultr, and HashiCorp/Terraform.
- Produce durable portfolio artifacts: runbooks, experiment reports, cost notes, and reproducibility logs.

## Non-goals

- No full Grok-1 training.
- No full-model fine-tuning unless explicitly planned in a separate issue.
- No secrets, API keys, DSNs, local checkpoint paths, or model weights committed.
- No long-running GPU jobs without a cost estimate and teardown plan.

## Repository layout

```text
providers/                 Provider-specific runbooks
terraform/                 Terraform/HCP notes and module layout
experiments/               Experiment reports and run records
docs/                      Cross-provider documentation and schemas
cost-ledger.md             Running estimate of cloud credit usage
```

## Provider strategy

| Provider | Primary role |
|---|---|
| DigitalOcean | First practical cloud GPU smoke-test target |
| AWS | SageMaker/S3/ECR/IAM MLOps practice and certification alignment |
| Azure | Azure ML/Blob/Key Vault practice and certification alignment |
| GCP / Vertex AI | Managed ML and AI platform practice |
| Vultr | Opportunistic GPU tests only, due to availability uncertainty |
| HashiCorp | Terraform/HCP control plane, not model compute |

## Run discipline

Every cloud run should include:

- Git commit SHA
- model slug
- SAAQ version
- telemetry source
- heartbeat mode
- provider and region
- GPU or instance type
- start/end time
- estimated cost
- artifacts produced
- teardown confirmation

Start with documentation and smoke tests. Scale only after local and cloud baselines are reproducible.
