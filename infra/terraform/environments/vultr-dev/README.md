# Vultr Dev Terraform Environment

This environment is a historical Terraform scaffold from the Vultr credit-window planning work before the `2026-05-28` deadline.

It is intentionally metadata-only by default and provisions no billable resources. Vultr is now inactive for near-term execution, so this scaffold must remain documentation/reference-only unless a future issue explicitly reactivates Vultr.

## Guardrails

- Do not plan new Vultr resources from this scaffold during the current inactive period.
- Do not upload/configure `VULTR_API_KEY` in HCP Terraform or local automation for this scaffold unless a future issue explicitly reactivates Vultr.
- Do not commit API keys, real `.tfvars`, state files, `.terraform/`, account screenshots, or generated artifacts.
- Leave `enable_no_gpu_smoke_resources = false` and `enable_gpu_smoke_resources = false`; these toggles fail validation until reviewed resource blocks are added in a future issue.

## HCP Terraform Mapping

Historical workspace name from the credit-window plan:

```text
dioscuri-cloud-vultr-dev
```

Do not create or update this workspace while Vultr is inactive.

Workspace variables:

| Name | Sensitive | Purpose |
|---|---:|---|
| `VULTR_API_KEY` | yes | Inactive; do not upload/configure unless a future issue reactivates Vultr |
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

This scaffold should validate without live credentials because it contains no resources or data sources. Do not provide live Vultr credentials for validation while Vultr remains inactive.

## Remote State

For HCP Terraform state, this historical scaffold previously mapped to `dioscuri-cloud-vultr-dev`. Do not create or update that remote-state mapping while Vultr remains inactive.

Do not commit the copied override file.

## Related Docs

- Vultr bootstrap: `providers/vultr/bootstrap.md`
- Credit inventory: `docs/credits/inventory.md`
- Cost ledger: `cost-ledger.md`
- No-GPU preflight: `experiments/vultr/no-gpu-preflight/README.md`
- GPU go/no-go: `experiments/vultr/gpu-go-no-go/README.md`
- GPU smoke readiness: `docs/runbooks/gpu-smoke-test-readiness.md`
- Teardown checklist: `docs/runbooks/teardown-checklist.md`
