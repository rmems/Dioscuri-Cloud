# HCP Terraform Provider Variable Map

This document maps HCP Terraform workspace variables to Terraform input names. **Do not commit values** for sensitive variables.

See also:
- `docs/hcp/workspaces.md` — workspace list and boundaries
- `docs/hcp/vcs-integration.md` — VCS and speculative plan setup
- `providers/ibm/bootstrap.md` — IBM CLI and bootstrap order
- `providers/oracle/bootstrap.md` — OCI CLI and bootstrap order

## Common variables (all active workspaces)

Attach via a shared HCP variable set where possible:

| HCP variable | Sensitive | Terraform variable (when used) | Notes |
|---|---|---|---|
| `environment` | no | `environment` | e.g. `dev` |
| `owner` | no | `owner` | Team or operator label (no account IDs) |
| `repo` | no | n/a | Set to `rmems/Dioscuri-Cloud` for audit context |
| `budget_cap_usd` | no | n/a | Per-experiment cap reference; see `docs/credits/usage-policy.md` |
| `provider_role` | no | n/a | e.g. `control-plane`, `ibm-dev`, `oracle-dev` |

## IBM Cloud (`dioscuri-cloud-ibm-dev`)

Workspace: `dioscuri-cloud-ibm-dev`  
Working directory: `terraform/envs/ibm-dev`

| HCP variable | Sensitive | Terraform variable | Notes |
|---|---|---|---|
| `IBMCLOUD_API_KEY` | yes | `ibmcloud_api_key` | API key from IBM console; never commit |
| `IBMCLOUD_REGION` | no | `ibmcloud_region` | Single home region for dev |
| `IBMCLOUD_RESOURCE_GROUP` | no | `ibmcloud_resource_group` | e.g. `dioscuri-cloud` (name only in docs) |

Transitional auth: static API key in HCP until OIDC/federation is configured (follow-up issue).

## Oracle Cloud (`dioscuri-cloud-oracle-dev`)

Workspace: `dioscuri-cloud-oracle-dev`  
Working directory: `terraform/envs/oracle-dev`

| HCP variable | Sensitive | Terraform variable (future) | Notes |
|---|---|---|---|
| `OCI_TENANCY_OCID` | yes | `tenancy_ocid` | Do not commit OCIDs to git |
| `OCI_USER_OCID` | yes | `user_ocid` | |
| `OCI_FINGERPRINT` | yes | `fingerprint` | API key fingerprint |
| `OCI_PRIVATE_KEY` | yes | `private_key` | PEM contents; HCP sensitive only |
| `OCI_REGION` | no | `region` | Home region for dev |
| `OCI_COMPARTMENT_OCID` | yes | `compartment_ocid` | Target compartment for resources |

Transitional auth: key-based `~/.oci/config` locally; mirror to HCP for remote runs. Migrate to workload identity when available.

## HCP core (`dioscuri-cloud-hcp-core`)

Workspace: `dioscuri-cloud-hcp-core`  
Working directory: `infra/terraform/environments/dev`

No provider credentials. Common variables only.

## Never commit

- `.tfvars`, `*.auto.tfvars`, `terraform.tfvars`
- `*.tfstate`, `*.tfstate.backup`, `.terraform/`
- Provider CLI config with secrets (`~/.ibmcloud/`, `~/.oci/config`, private keys)
- HCP tokens, API keys, service account JSON, screenshots with account identifiers
