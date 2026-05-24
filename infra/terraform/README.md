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
  remote_state_override.tf.example   Example HCP Terraform remote-state config

  modules/
    onboarding_baseline/      Minimal provider-neutral module for shared metadata

  environments/
    dev/                      Small onboarding environment composition
      remote_state_override.tf  Local-only copied backend override (untracked)
    vultr-dev/                Safe Vultr metadata scaffold for credit-window smoke tests
```

## Design Notes

- Terraform is the infrastructure control layer.
- Provider-specific work will be added incrementally for IBM, GCP, DigitalOcean, AWS, Azure, and Vultr.
- Secrets and credentials must stay out of git.
- This scaffold is safe to validate locally without committed backend credentials.

## Remote State

Run environments should use HCP Terraform remote state rather than local state files.

Recommended model:
- one HCP Terraform workspace per run environment
- one state file per environment folder
- no shared workspace spanning unrelated environments

Current environment mapping:
- `infra/terraform/environments/dev` -> `dioscuri-cloud-run-dev`
- `infra/terraform/environments/vultr-dev` -> `dioscuri-cloud-vultr-dev`

Future environments should follow the same shape, for example:
- `infra/terraform/environments/staging` -> `dioscuri-cloud-run-staging`
- `infra/terraform/environments/prod` -> `dioscuri-cloud-run-prod`

The tracked file `remote_state_override.tf.example` defines the intended backend shape for run environments using HCP Terraform in organization `Limen-Neural`.
Its workspace name is intentionally a placeholder so operators must replace it with the exact environment workspace instead of accidentally reusing `dev` state.
Copy its contents into the specific environment root module that will be initialized.

### Safe Local Usage

Do not rename the example file in git.

To enable remote state locally:
- copy infra/terraform/remote_state_override.tf.example to the target environment directory (e.g., infra/terraform/environments/dev/remote_state_override.tf)
- replace `REPLACE_WITH_DIOSCURI_CLOUD_RUN_WORKSPACE` with the exact workspace for that environment (e.g. `dioscuri-cloud-run-dev`)
- keep the copied file untracked (it is already ignored by the repo-wide `*_override.tf` rule)
- run `terraform login` or provide an HCP token via environment variables

This keeps backend credentials and local operator-specific choices out of the repository.

### Credential and State Safety

- Do not commit HCP tokens, provider credentials, or `.terraform/` artifacts.
- Do not commit local state files.
- Treat HCP Terraform as the canonical state location for run environments.
- If a workspace is renamed, migrate state intentionally rather than creating a second workspace accidentally.
- Do not point two run environments at the same workspace/state.

## Validation

```bash
terraform -chdir=infra/terraform fmt -recursive

# Sanity-check the scaffold root only (required_version / backend-shape only)
terraform -chdir=infra/terraform init

# Validate the actual run environment module
terraform -chdir=infra/terraform/environments/dev init -backend=false
terraform -chdir=infra/terraform/environments/dev validate

# Validate the safe Vultr scaffold; no resources are provisioned by default
terraform -chdir=infra/terraform/environments/vultr-dev init -backend=false
terraform -chdir=infra/terraform/environments/vultr-dev validate
```
