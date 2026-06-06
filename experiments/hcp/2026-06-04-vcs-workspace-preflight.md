# HCP VCS workspace preflight (2026-06-04)

Public-safe run record for GitHub issue #46: HCP Terraform control-plane setup for `rmems/Dioscuri-Cloud`.

## Scope

- Organization: `Dioscuri-Cloud`
- Active workspaces: `dioscuri-cloud-hcp-core`, `dioscuri-cloud-ibm-dev`, `dioscuri-cloud-oracle-dev`
- No provider credentials, OCIDs, API keys, or account identifiers in this document.

## Repo changes (PR #51)

- Standardized workspace -> working directory mapping in `docs/hcp/workspaces.md`
- VCS runbook updated in `docs/hcp/vcs-integration.md`
- Added `docs/hcp/provider-variable-map.md` (Category column, scaffold inputs)
- Added `terraform/envs/oracle-dev` skeleton + ibm-dev defaults
- Added `scripts/hcp/bootstrap-workspaces.sh` for API bootstrap
- Renamed infra dev workspace target from `dioscuri-cloud-run-dev` to `dioscuri-cloud-hcp-core` in docs

## CLI preflight (updated 2026-06-05)

| Tool | Status | Notes |
|---|---|---|
| `terraform` v1.15.3 | **ok** | Org `Dioscuri-Cloud` verified on `app.terraform.io` |
| `ibmcloud` v2.43.1 | **ok** | Region `us-south`; RG `dioscuri-cloud` — see `experiments/ibm/2026-06-05-account-preflight.md` |
| `oci` v3.85.0 (`~/bin/oci`) | **ok** | Home region `us-phoenix-1`; bucket `dioscuri-cloud-dev-artifacts` verified |

**Agent shell note:** PATH must include `$HOME/bin` for `oci`. Add to `~/.bashrc` if missing:

```bash
export PATH="$HOME/bin:$PATH"
```

## HCP workspace inventory (API bootstrap 2026-06-05)

Bootstrapped via `scripts/hcp/bootstrap-workspaces.sh --sync-oci-from-local --link-vcs`.

| Workspace | Status | Working dir matches repo | Speculative plans | Manual apply | Notes |
|---|---|---|---|---|---|
| `dioscuri-cloud-hcp-core` | **created/patched** | `infra/terraform/environments/dev` | enabled | manual | ID `ws-oNa3d8rqvEcbmnQU`; scaffold vars set |
| `dioscuri-cloud-ibm-dev` | **created** | `terraform/envs/ibm-dev` | enabled | manual | ID `ws-suJGJJkiaVzTayjH`; scaffold vars set |
| `dioscuri-cloud-oracle-dev` | **created** | `terraform/envs/oracle-dev` | enabled | manual | ID `ws-wrpz7CKPoC16SNeT`; scaffold + OCI env vars synced from local |

## VCS status

| Item | Status | Blocker |
|---|---|---|
| HashiCorp GitHub app | **not installed** | Org `Dioscuri-Cloud` has 0 OAuth tokens |
| Repo linked to workspaces | **blocked** | Install app: HCP UI → Settings → VCS Providers → Connect GitHub → grant `rmems/Dioscuri-Cloud` |
| Re-run after install | pending | `./scripts/hcp/bootstrap-workspaces.sh --link-vcs` |

## Speculative plan validation (test PR)

| Workspace | PR link | Plan result | Blocker (if any) |
|---|---|---|---|
| `dioscuri-cloud-hcp-core` | [#51](https://github.com/rmems/Dioscuri-Cloud/pull/51) | **blocked** | VCS not linked (no GitHub app / OAuth token) |
| `dioscuri-cloud-ibm-dev` | [#51](https://github.com/rmems/Dioscuri-Cloud/pull/51) | **blocked** | VCS not linked |
| `dioscuri-cloud-oracle-dev` | [#51](https://github.com/rmems/Dioscuri-Cloud/pull/51) | **blocked** | VCS not linked |

Per issue #46 acceptance: speculative plans are **documented as blocked** with reproducible steps above until the HashiCorp GitHub app is installed.

## Credit separation

- HashiCorp student credits: **ready** — org `Dioscuri-Cloud` exists; three workspaces configured; burns on first remote plan/apply.
- IBM `$200`: **bootstrap started** — `dioscuri-cloud` resource group (no COS/compute yet).
- Oracle `$300`: **first resource live** — bucket `dioscuri-cloud-dev-artifacts`; see `cost-ledger.md` row `2026-06-04`.

## Security confirmation

- [x] No `.tfvars`, state files, or API material in the PR diff
- [x] GitHub Actions `terraform-validate` workflow green on PR #51 ([run 27047359680](https://github.com/rmems/Dioscuri-Cloud/actions/runs/27047359680))
