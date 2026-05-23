# Infra Terraform Onboarding Skeleton

This directory is the initial Terraform control layer for cloud onboarding workflows in `Dioscuri-Cloud`.

It is intentionally small:
- no provider credentials
- no provider-specific resources
- no managed ML infrastructure

The goal is to establish the shape of the infrastructure code so future provider work can plug into a stable baseline.

## Layout

```text
infra/terraform/
  modules/
    onboarding_baseline/      Minimal provider-neutral module for shared metadata

  environments/
    dev/                      Small onboarding environment composition
```

## Design Notes

- Terraform is the infrastructure control layer.
- Provider-specific work will be added later for IBM, GCP, DigitalOcean, AWS, and Azure.
- Secrets and credentials must stay out of git.
- This scaffold is safe to validate with `terraform init -backend=false`.

## Validation

```bash
terraform -chdir=infra/terraform fmt -recursive
terraform -chdir=infra/terraform/environments/dev init -backend=false
terraform -chdir=infra/terraform/environments/dev validate
```
