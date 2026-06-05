# HCP VCS workspace preflight (2026-06-04)

Public-safe run record for GitHub issue #46: HCP Terraform control-plane setup for `rmems/Dioscuri-Cloud`.

## Scope

- Organization: `Limen-Neural`
- Active workspaces (intended): `dioscuri-cloud-hcp-core`, `dioscuri-cloud-ibm-dev`, `dioscuri-cloud-oracle-dev`
- No provider credentials, OCIDs, API keys, or account identifiers in this document.

## Repo changes (this PR)

- Standardized workspace -> working directory mapping in `docs/hcp/workspaces.md`
- VCS runbook updated in `docs/hcp/vcs-integration.md`
- Added `docs/hcp/provider-variable-map.md`
- Added `terraform/envs/oracle-dev` skeleton
- Added `providers/oracle/bootstrap.md`
- Renamed infra dev workspace target from `dioscuri-cloud-run-dev` to `dioscuri-cloud-hcp-core` in docs

## HCP workspace inventory (operator: fill after UI review)

| Workspace | Status | Working dir matches repo | Speculative plans | Manual apply | Notes |
|---|---|---|---|---|---|
| `dioscuri-cloud-hcp-core` | TBD | `infra/terraform/environments/dev` | TBD | TBD | |
| `dioscuri-cloud-ibm-dev` | TBD | `terraform/envs/ibm-dev` | TBD | TBD | |
| `dioscuri-cloud-oracle-dev` | TBD | `terraform/envs/oracle-dev` | TBD | TBD | |

## CLI preflight (local machine; not committed)

| Tool | Status | Notes |
|---|---|---|
| `terraform` + `terraform login` | TBD | HCP org `Limen-Neural` |
| `ibmcloud` | TBD | See `providers/ibm/bootstrap.md` |
| `oci` | TBD | See `providers/oracle/bootstrap.md` |

## Speculative plan validation (test PR)

| Workspace | PR link | Plan result | Blocker (if any) |
|---|---|---|---|
| `dioscuri-cloud-hcp-core` | TBD | TBD | |
| `dioscuri-cloud-ibm-dev` | TBD | TBD | |
| `dioscuri-cloud-oracle-dev` | TBD | TBD | |

## Credit separation

- HashiCorp student credits: HCP control-plane runs only (`docs/credits/inventory.md`).
- IBM / Oracle credits: provider resources only; track in `cost-ledger.md` when billable work starts.

## Security confirmation

- [ ] No `.tfvars`, state files, or API material in the PR diff
- [ ] GitHub Actions `terraform-validate` workflow green on the PR branch
