# Vultr Dev Terraform Environment

This environment is the safe Terraform scaffold for Vultr smoke-test planning before the `2026-05-28` credit deadline.

It is intentionally metadata-only by default and provisions no billable resources.

## Guardrails

- Default experiment cap: `$25` unless explicitly approved.
- Same-day teardown is required for any future Vultr resource.
- `VULTR_API_KEY` must come from the shell environment or an HCP Terraform sensitive variable.
- Do not commit API keys, real `.tfvars`, state files, `.terraform/`, account screenshots, or generated artifacts.
- Leave `enable_no_gpu_smoke_resources = false` and `enable_gpu_smoke_resources = false`; these toggles fail validation until reviewed resource blocks are added in a future issue.

## HCP Terraform Mapping

Recommended workspace:

```text
dioscuri-cloud-vultr-dev
```

This follows the repo-wide convention in `docs/hcp/workspaces.md`.

Workspace variables:

| Name | Sensitive | Purpose |
|---|---:|---|
| `VULTR_API_KEY` | yes | Vultr provider authentication |
| `TF_VAR_owner` | no | Resource owner label, for example `rmems` in the Vultr credit-window runbook |
| `TF_VAR_region` | no | Vultr region slug |
| `TF_VAR_resource_name_prefix` | no | Resource name prefix |
| `TF_VAR_teardown_by` | no | Teardown deadline |

## Local Validation

```bash
terraform -chdir=infra/terraform/environments/vultr-dev fmt -recursive
terraform -chdir=infra/terraform/environments/vultr-dev init -backend=false
terraform -chdir=infra/terraform/environments/vultr-dev validate
```

The provider block reads `VULTR_API_KEY` from the environment when a plan or apply needs it. This scaffold should validate without live credentials because it contains no resources or data sources.

## Remote State

For HCP Terraform state, copy `infra/terraform/remote_state_override.tf.example` into this directory as an untracked local file named `remote_state_override.tf`, then replace `REPLACE_WITH_DIOSCURI_CLOUD_RUN_WORKSPACE` with `dioscuri-cloud-vultr-dev`.

Do not commit the copied override file.

## Related Docs

- Vultr bootstrap: `providers/vultr/bootstrap.md`
- Credit inventory: `docs/credits/inventory.md`
- Cost ledger: `cost-ledger.md`
- No-GPU preflight: `experiments/vultr/no-gpu-preflight/README.md`
- GPU go/no-go: `experiments/vultr/gpu-go-no-go/README.md`
- GPU smoke readiness: `docs/runbooks/gpu-smoke-test-readiness.md`
- Teardown checklist: `docs/runbooks/teardown-checklist.md`
