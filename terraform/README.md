# Terraform in SAAQ Cloud ML Lab

## Purpose
Terraform in this repo captures reproducible cloud infrastructure patterns for smoke tests and MLOps lab workflows, not production-scale deployment.

## Provider module strategy
Create small, provider-focused modules with shared tagging/metadata helpers. Keep modules scoped to lab-grade, teardown-friendly resources.

## Recommended module layout
- `modules/digitalocean_gpu_smoke`
- `modules/aws_artifact_pipeline`
- `modules/azure_ml_smoke`
- `modules/gcp_vertex_smoke`
- `modules/common_tags`

## Remote state / HCP notes
- Prefer remote state backed by Terraform Cloud/HCP workspaces.
- Separate workspaces by provider and environment purpose.
- Keep variable and state access least-privilege.

## Plan/apply/destroy workflow
1. Initialize workspace/backend.
2. Run `terraform fmt` and `terraform validate`.
3. Run `terraform plan` and review output.
4. Apply only after review/approval.
5. Document and run destroy path when test completes.

## Safety rules
- Run `terraform plan` before any `apply`.
- Never commit `*.tfvars` files containing secrets.
- Always document the exact destroy command used.
