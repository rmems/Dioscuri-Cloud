# HashiCorp Runbook

## Purpose
Terraform/HCP control-plane management for reproducible infra workflows.

## Important boundary
HashiCorp is not a compute provider for model runs.

## Primary uses
- Terraform remote state handling
- Workspace/environment organization
- Variable management strategy
- Reproducible infrastructure plans

## Rules
- No `terraform apply` without review.
- No secrets in state when avoidable.
- Always document the destroy path for provisioned resources.

## Cost notes
- Monitor HCP/Terraform usage as control-plane spend, separate from GPU runtime cost.
