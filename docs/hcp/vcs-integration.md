# HCP Terraform VCS Integration (GitHub)

This runbook documents how to connect this repository to HCP Terraform using GitHub VCS integration.

Goal: remote state + plan/apply history + speculative plans on pull requests.

## Prerequisites

- HCP Terraform organization: `Limen-Neural`.
- Access to the GitHub repo: `rmems/Dioscuri-Cloud`.
- Workspace naming convention: see `docs/hcp/workspaces.md`.
- Provider credentials (or OIDC configuration) must be configured as HCP Terraform workspace variables.
  - Do not commit provider credentials to git.
  - Do not use `.tfvars` files for secrets.

## Recommended Workspace Settings

Create (or reuse) a workspace matching the naming convention, for example:
- `dioscuri-cloud-gcp-artifacts`
- `dioscuri-cloud-ibm-dev`

Settings to apply:

1. **VCS connection**
   - Connect workspace to GitHub and select repo `rmems/Dioscuri-Cloud`.

2. **Working directory**
   - Set the working directory to the env that the workspace controls:
     - `terraform/envs/gcp-artifacts`
     - `terraform/envs/ibm-dev`

3. **Execution mode**
   - Recommended: Remote execution.
   - Local execution is discouraged for this repo because it increases the chance of untracked local state and inconsistent tooling.

4. **Speculative plans**
   - Enable speculative plans for pull requests.
   - This ensures PRs get a plan without applying.

5. **Auto-apply policy**
   - Recommended default: manual apply.
   - If you enable auto-apply later, do it only for narrowly scoped, low-risk workspaces and document the rationale.

## Secrets and Variables

All provider auth must be configured via HCP Terraform workspace variables (marked sensitive where appropriate).

Examples (non-exhaustive):

- GCP (temporary until OIDC is added):
  - `GOOGLE_PROJECT`
  - `GOOGLE_REGION`
  - `GOOGLE_CREDENTIALS` (sensitive JSON)

- IBM (temporary until OIDC/federation is added):
  - `IBMCLOUD_API_KEY` (sensitive)
  - `IBMCLOUD_REGION`

Also consider non-secret variables:
- `owner`
- `environment`
- `budget_cap_usd`

## How Runs Relate To GitHub Actions

This repo uses GitHub Actions for a cheap, public-safe quality gate:
- formatting checks (`terraform fmt -check`)
- limited validation for module skeletons

HCP Terraform runs are different:
- they run remote plans/applies for a specific workspace
- they maintain the canonical remote state
- they can post speculative plan results to pull requests

If GitHub Actions is green but HCP Terraform fails, treat HCP Terraform as the source of truth for plan/apply correctness.

## Test Checklist (Confirm PR Triggers A Plan)

1. Workspace is connected to GitHub repo `rmems/Dioscuri-Cloud`.
2. Workspace working directory is set correctly (e.g. `terraform/envs/gcp-artifacts`).
3. Speculative plans are enabled.
4. A PR changes Terraform files within that working directory.
5. The PR shows an HCP Terraform status/check and links to the speculative plan.
6. The plan output shows the expected diff and no missing-variable/provider-auth errors.

## Troubleshooting

### No plan appears on PR
- Confirm VCS connection is active and has access to the repo.
- Confirm speculative plans are enabled for the workspace.
- Confirm the working directory points at the env folder that changed.

### Plan fails with missing variables
- Add required variables in the workspace variables UI.
- Ensure secrets are marked sensitive.
- Confirm variable names match provider expectations.

### Provider authentication fails
- Ensure credentials/OIDC is configured for the provider.
- Avoid using local credential files; prefer workspace variables.
- For service-account JSON (GCP), ensure the JSON is valid and complete.

### State or locking errors
- Ensure the workspace is the only writer for that working directory.
- Avoid multiple workspaces pointing at the same env path.
