# saaq-cloud-ml-lab

SAAQ Cloud ML Lab is the cloud/MLOps companion repository for SAAQ experimentation.  
The core SAAQ implementation (Rust/CUDA and core runtime work) lives in **`rmems/corinth-canal`**.

This repository focuses on:
- cloud GPU smoke-test runbooks,
- cloud credit and cost tracking,
- Terraform/HashiCorp control-plane notes,
- provider operations guides,
- reproducible experiment records,
- New Relic dashboard planning,
- artifact/report schema documentation.

## Scope and intent

This is a **cost-controlled lab** for reproducibility and MLOps practice. It is not a production deployment repo and not a full-training roadmap.

### What this repo tracks
- Provider runbooks (`providers/`)
- Cloud credit inventory and run-level cost ledger (`cost-ledger.md`)
- Terraform/HCP guidance and planned module layout (`terraform/`)
- Experiment reports and templates (`experiments/`, `docs/run-record-template.md`)
- Model lineup planning and verification status (`docs/model-lineup.md`)
- New Relic dashboard plans and safe telemetry fields (`docs/new-relic-dashboard.md`)
- Artifact schema and manifest expectations (`docs/artifact-schema.md`)

## Provider strategy

| Provider | Role in this lab |
|---|---|
| DigitalOcean | First practical GPU smoke-test target |
| AWS | S3/ECR/SageMaker/IAM MLOps practice and certification alignment |
| Azure | Azure ML/Blob/Key Vault practice and certification alignment |
| GCP / Vertex AI | Managed ML and AI platform practice |
| Vultr | Opportunistic GPU tests only, due to potentially weak availability |
| HashiCorp | Terraform/HCP control plane, not model compute |

## Cloud run discipline

Every run record must include:
- `model_slug`
- provider + region
- instance type / GPU type
- `git_sha`
- SAAQ version
- runtime
- estimated cost
- artifacts produced
- teardown confirmation

Also required:
- no secrets committed,
- no claims of completed cloud runs without evidence,
- no long-running GPU jobs without an estimate and teardown plan.

## Repository layout

```text
providers/                 Provider-specific runbooks
terraform/                 Terraform/HCP notes and planned modules
experiments/               Experiment run reports (no fabricated results)
docs/                      Cross-provider runbook/schema/dashboard docs
cost-ledger.md             Credit inventory + run-level cost ledger
```

See `docs/cloud-gpu-runbook.md` for the generalized run workflow.
