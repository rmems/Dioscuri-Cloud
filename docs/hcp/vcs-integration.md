# HCP Terraform VCS Integration (GitHub)

This runbook documents how to connect this repository to HCP Terraform using GitHub VCS integration.

Goal: remote state + plan/apply history + speculative plans on pull requests.

## Prerequisites

- HCP Terraform organization: `Dioscuri-Cloud`.
- Access to the GitHub repo: `rmems/Dioscuri-Cloud`.
- Workspace naming and directories: see `docs/hcp/workspaces.md`.
- Provider credentials (or OIDC configuration) must be configured as HCP Terraform workspace variables.
  - Do not commit provider credentials to git.
  - Do not use `.tfvars` files for secrets.

## Active workspaces (VCS settings)

Create or align these three workspaces in HCP Terraform:

| Workspace | Working directory |
|---|---|
| `dioscuri-cloud-hcp-core` | `infra/terraform/environments/dev` |
| `dioscuri-cloud-ibm-dev` | `terraform/envs/ibm-dev` |
| `dioscuri-cloud-oracle-dev` | `terraform/envs/oracle-dev` |

### Per-workspace checklist

1. **VCS connection**
   - Connect workspace to GitHub repository `rmems/Dioscuri-Cloud`.
   - Install the HashiCorp GitHub app if prompted.

2. **Working directory**
   - Set exactly to the path in the table above (no leading slash).

3. **Execution mode**
   - Remote execution (recommended).
   - Local execution is discouraged (untracked state risk).

4. **Speculative plans**
   - Enable for pull requests.

5. **Apply**
   - Manual apply only (default for all workspaces in this repo).

6. **Variables**
   - Common (all workspaces): `environment`, `owner`, `repo`, `budget_cap_usd` (non-secret).
   - Scaffold Terraform variables (required for speculative plans today; see `docs/hcp/provider-variable-map.md`):
     - `dioscuri-cloud-hcp-core`: `project_name`, `environment`, `owner` (defaults exist in code; optional in HCP).
     - `dioscuri-cloud-ibm-dev`: `location`, `artifact_bucket_name`, `service_account_name` (defaults exist in code).
     - `dioscuri-cloud-oracle-dev`: `location`, `artifact_bucket_name`, `service_account_name` (defaults exist in code).
   - Planned provider auth (not active until #47/#48):
     - IBM workspace: `IBMCLOUD_*` as **Environment variables**.
     - Oracle workspace: `OCI_*` as **Environment variables**.
   - Mark all credentials sensitive in HCP; never commit values to GitHub.

## Automated bootstrap (API)

Run `scripts/hcp/bootstrap-workspaces.sh` to create missing workspaces, set working directories, and apply scaffold Terraform variables. Requires `terraform login` (token in `~/.terraform.d/credentials.tfrc.json`).

Optional flags (secrets stay local; never committed):
- `--sync-oci-from-local` — mirror `~/.oci/config` to oracle-dev environment variables.
- `--sync-ibm-from-env` — mirror `IBMCLOUD_*` shell env vars to ibm-dev environment variables.

## Manual HCP UI steps (operator)

1. Sign in to HCP Terraform and open organization `Dioscuri-Cloud`.
2. Run `scripts/hcp/bootstrap-workspaces.sh` (or confirm workspaces already match the table).
3. Install the HashiCorp GitHub app if no VCS provider exists (Settings → VCS Providers → Connect GitHub).
4. For each workspace in the table, confirm name, VCS link, and working directory.
5. Enable speculative plans; confirm auto-apply is off.
6. Attach variable sets: common set to all three; IBM/OCI sets only to matching workspaces.
7. Open a test PR that touches files under one working directory; confirm an HCP speculative plan appears on the PR.

## Secrets and variables

All provider auth must be configured via HCP Terraform workspace variables (marked sensitive where appropriate).

See `docs/hcp/provider-variable-map.md` for the canonical name mapping.

## How runs relate to GitHub Actions

This repo uses GitHub Actions for a cheap, public-safe quality gate:
- formatting checks (`terraform fmt -check`)
- limited validation for module skeletons and selected environments

HCP Terraform runs are different:
- they run remote plans/applies for a specific workspace
- they maintain the canonical remote state
- they can post speculative plan results to pull requests

If GitHub Actions is green but HCP Terraform fails, treat HCP Terraform as the source of truth for plan/apply correctness.

## Test checklist (confirm PR triggers a plan)

1. Workspace is connected to GitHub repo `rmems/Dioscuri-Cloud`.
2. Workspace working directory matches the table above.
3. Speculative plans are enabled.
4. A PR changes Terraform or README files within that working directory.
5. The PR shows an HCP Terraform status/check and links to the speculative plan.
6. The plan output shows the expected diff and no missing-variable/provider-auth errors (provider auth may be deferred while skeletons have no provider blocks).

## Troubleshooting

### No plan appears on PR
- Confirm VCS connection is active and has access to the repo.
- Confirm speculative plans are enabled for the workspace.
- Confirm the working directory points at the env folder that changed.

### Plan fails with missing variables
- Add required variables in the workspace variables UI.
- Ensure secrets are marked sensitive.
- Confirm variable names match `docs/hcp/provider-variable-map.md`.

### Provider authentication fails
- Ensure credentials are set only in HCP (or local CLI for debugging), not in git.
- For OCI, ensure the private key PEM is complete in the sensitive variable.
- Follow `providers/ibm/bootstrap.md` and `providers/oracle/bootstrap.md` for CLI preflight.

### State or locking errors
- Ensure the workspace is the only writer for that working directory.
- Avoid multiple workspaces pointing at the same env path.

### Wrong Terraform tree
- Control-plane onboarding: `infra/terraform/environments/dev` -> `dioscuri-cloud-hcp-core`.
- Provider stacks: `terraform/envs/<provider>-dev` -> matching `dioscuri-cloud-<provider>-dev` workspace.
