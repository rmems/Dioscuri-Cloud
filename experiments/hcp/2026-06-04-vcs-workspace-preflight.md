# HCP VCS workspace preflight (2026-06-04)

Public-safe run record for GitHub issue #46: HCP Terraform control-plane setup for `rmems/Dioscuri-Cloud`.

## Scope

- Organization: `Limen-Neural`
- Active workspaces (intended): `dioscuri-cloud-hcp-core`, `dioscuri-cloud-ibm-dev`, `dioscuri-cloud-oracle-dev`
- No provider credentials, OCIDs, API keys, or account identifiers in this document.

## Repo changes (PR #51)

- Standardized workspace -> working directory mapping in `docs/hcp/workspaces.md`
- VCS runbook updated in `docs/hcp/vcs-integration.md`
- Added `docs/hcp/provider-variable-map.md`
- Added `terraform/envs/oracle-dev` skeleton
- Added `providers/oracle/bootstrap.md`
- Renamed infra dev workspace target from `dioscuri-cloud-run-dev` to `dioscuri-cloud-hcp-core` in docs

## CLI preflight (2026-06-04 local verification)

| Tool | Status | Notes |
|---|---|---|
| `terraform` v1.15.3 | **blocked** | `~/.terraform.d/credentials.tfrc.json` missing; run `terraform login` and paste HCP token (browser flow) |
| `ibmcloud` v2.43.1 | **blocked** | API endpoint set; `~/.bluemix` session empty — run `ibmcloud login` or `ibmcloud login --apikey "$IBMCLOUD_API_KEY"` |
| `oci` v3.85.0 (`~/bin/oci`) | **ok** | Auth works; home region `us-phoenix-1`; first bucket created (see `experiments/oracle/2026-06-04-object-storage-bootstrap.md`) |

**Agent shell note:** PATH must include `$HOME/bin` for `oci`. Add to `~/.bashrc` if missing:

```bash
export PATH="$HOME/bin:$PATH"
```

## HCP workspace inventory (operator: fill after UI review)

| Workspace | Status | Working dir matches repo | Speculative plans | Manual apply | Notes |
|---|---|---|---|---|---|
| `dioscuri-cloud-hcp-core` | TBD | `infra/terraform/environments/dev` | TBD | TBD | Requires `terraform login` |
| `dioscuri-cloud-ibm-dev` | TBD | `terraform/envs/ibm-dev` | TBD | TBD | Requires `ibmcloud login` |
| `dioscuri-cloud-oracle-dev` | TBD | `terraform/envs/oracle-dev` | TBD | TBD | OCI CLI ready; mirror creds to HCP vars |

## Speculative plan validation (test PR)

| Workspace | PR link | Plan result | Blocker (if any) |
|---|---|---|---|
| `dioscuri-cloud-hcp-core` | [#51](https://github.com/rmems/Dioscuri-Cloud/pull/51) | TBD | `terraform login` not completed in automation shell |
| `dioscuri-cloud-ibm-dev` | [#51](https://github.com/rmems/Dioscuri-Cloud/pull/51) | TBD | `ibmcloud` not logged in |
| `dioscuri-cloud-oracle-dev` | [#51](https://github.com/rmems/Dioscuri-Cloud/pull/51) | TBD | HCP workspace + OCI vars not configured yet |

## Credit separation

- HashiCorp student credits: HCP control-plane runs only (`docs/credits/inventory.md`) — **not used yet** (no `terraform login`).
- IBM `$200`: **not used yet** (CLI session missing).
- Oracle `$300`: **first resource created** — empty object storage bucket; see `cost-ledger.md` row `2026-06-04`.

## Security confirmation

- [x] No `.tfvars`, state files, or API material in the PR diff
- [ ] GitHub Actions `terraform-validate` workflow green on the PR branch
