# HCP VCS workspace preflight (2026-06-04)

Public-safe run record for GitHub issue #46: HCP Terraform control-plane setup for `rmems/Dioscuri-Cloud`.

## Scope

- Organization: `Dioscuri-Cloud`
- Active workspaces (intended): `dioscuri-cloud-hcp-core`, `dioscuri-cloud-ibm-dev`, `dioscuri-cloud-oracle-dev`
- No provider credentials, OCIDs, API keys, or account identifiers in this document.

## Repo changes (PR #51)

- Standardized workspace -> working directory mapping in `docs/hcp/workspaces.md`
- VCS runbook updated in `docs/hcp/vcs-integration.md`
- Added `docs/hcp/provider-variable-map.md`
- Added `terraform/envs/oracle-dev` skeleton
- Added `providers/oracle/bootstrap.md`
- Renamed infra dev workspace target from `dioscuri-cloud-run-dev` to `dioscuri-cloud-hcp-core` in docs

## CLI preflight (updated 2026-06-05)

| Tool | Status | Notes |
|---|---|---|
| `terraform` v1.15.3 | **ok** | Org `Dioscuri-Cloud` verified on `app.terraform.io`; remote `terraform init` pending workspace creation |
| `ibmcloud` v2.43.1 | **ok** | Region `us-south`; RG `dioscuri-cloud` created; COS plugin installed — see `experiments/ibm/2026-06-05-account-preflight.md` |
| `oci` v3.85.0 (`~/bin/oci`) | **ok** | Home region `us-phoenix-1`; bucket `dioscuri-cloud-dev-artifacts` verified |

**Agent shell note:** PATH must include `$HOME/bin` for `oci`. Add to `~/.bashrc` if missing:

```bash
export PATH="$HOME/bin:$PATH"
```

## HCP workspace inventory (operator: fill after UI review)

| Workspace | Status | Working dir matches repo | Speculative plans | Manual apply | Notes |
|---|---|---|---|---|---|
| `dioscuri-cloud-hcp-core` | org ready | `infra/terraform/environments/dev` | TBD | manual | `terraform init` OK against org `Dioscuri-Cloud`; create workspace in HCP UI if missing |
| `dioscuri-cloud-ibm-dev` | org ready | `terraform/envs/ibm-dev` | TBD | manual | Create workspace + VCS link in HCP UI |
| `dioscuri-cloud-oracle-dev` | org ready | `terraform/envs/oracle-dev` | TBD | manual | Create workspace + VCS link in HCP UI |

## Speculative plan validation (test PR)

| Workspace | PR link | Plan result | Blocker (if any) |
|---|---|---|---|
| `dioscuri-cloud-hcp-core` | [#51](https://github.com/rmems/Dioscuri-Cloud/pull/51) | TBD | `terraform login` not completed in automation shell |
| `dioscuri-cloud-ibm-dev` | [#51](https://github.com/rmems/Dioscuri-Cloud/pull/51) | TBD | `ibmcloud` not logged in |
| `dioscuri-cloud-oracle-dev` | [#51](https://github.com/rmems/Dioscuri-Cloud/pull/51) | TBD | HCP workspace + OCI vars not configured yet |

## Credit separation

- HashiCorp student credits: **ready** — org `Dioscuri-Cloud` exists; burns on first HCP workspace run.
- IBM `$200`: **bootstrap started** — `dioscuri-cloud` resource group (no COS/compute yet).
- Oracle `$300`: **first resource live** — bucket `dioscuri-cloud-dev-artifacts`; see `cost-ledger.md` row `2026-06-04`.

## Security confirmation

- [x] No `.tfvars`, state files, or API material in the PR diff
- [ ] GitHub Actions `terraform-validate` workflow green on the PR branch
