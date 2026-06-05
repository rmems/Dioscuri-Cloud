# HCP Terraform Workspaces

This document defines the HCP Terraform workspace layout and naming convention for this repo.

HCP Terraform is the control plane for infrastructure state, policy, and drift detection. GPU/ML compute spend is owned by the cloud providers (AWS/Azure/GCP/DO/Vultr/etc.), not by HashiCorp credits.

## Goals
- Keep ownership boundaries clear (one workspace == one blast radius).
- Make it obvious which provider/environment a workspace controls.
- Keep state isolated between providers and between long-lived vs experiment infra.
- Support GitHub VCS integration later without renaming everything.

## Organization Layout
HCP Terraform organization: `Limen-Neural`.

Recommended structure inside a single HCP Terraform org:
- Folder/Project grouping (in HCP UI):
  - `dioscuri-cloud/core` for shared primitives and control-plane wiring.
  - `dioscuri-cloud/providers/*` for provider-specific infrastructure.
  - `dioscuri-cloud/experiments/*` for short-lived experiment stacks.

If HCP foldering is not used, keep the same grouping via workspace names.

## Naming Convention

Format:

`dioscuri-cloud-<scope>`

Where `<scope>` is one of:
- `hcp-core`
- `<provider>-<purpose>`
- `<provider>-<env>-<purpose>` (only when you truly need separate environments)

Rules:
- Always prefix with `dioscuri-cloud-`.
- Use lowercase and hyphens only.
- Avoid embedding usernames.
- If the workspace is experiment-scoped, include an experiment slug at the end.

Examples (from Issue #3):
- `dioscuri-cloud-hcp-core`
- `dioscuri-cloud-ibm-dev`
- `dioscuri-cloud-gcp-artifacts`
- `dioscuri-cloud-do-gpu-smoke`
- `dioscuri-cloud-aws-mlops`
- `dioscuri-cloud-azure-mlops`
- `dioscuri-cloud-vultr-dev`

Additional recommended examples:
- `dioscuri-cloud-aws-dev-mlops` (if dev/prod separation is required)
- `dioscuri-cloud-gcp-exp-<slug>` (short-lived experiment stack)

## Active workspaces (Issue #46)

Organization: `Limen-Neural`  
Repository: `rmems/Dioscuri-Cloud`  
Default apply mode: **manual** (no global auto-apply)  
Default execution: **remote**  
Speculative plans: **enabled** on pull requests

Recommended HCP project/folder grouping (optional in UI):
- `dioscuri-cloud/core` -> `dioscuri-cloud-hcp-core`
- `dioscuri-cloud/providers/ibm` -> `dioscuri-cloud-ibm-dev`
- `dioscuri-cloud/providers/oracle` -> `dioscuri-cloud-oracle-dev`

| Workspace | Working directory | State boundary | Provider mapping | Variable set strategy |
|---|---|---|---|---|
| `dioscuri-cloud-hcp-core` | `infra/terraform/environments/dev` | HCP control-plane / onboarding metadata only | None | Common variables only |
| `dioscuri-cloud-ibm-dev` | `terraform/envs/ibm-dev` | IBM dev account / resource group | IBM Cloud | Common + IBM (`IBMCLOUD_*`) |
| `dioscuri-cloud-oracle-dev` | `terraform/envs/oracle-dev` | Oracle dev tenancy / compartment | Oracle Cloud | Common + OCI (`OCI_*`) |

IBM and Oracle workspaces must remain isolated (separate state, separate sensitive variable sets).

Variable names: `docs/hcp/provider-variable-map.md`  
VCS setup: `docs/hcp/vcs-integration.md`

## Deferred workspaces (document only; do not create unless needed)

| Workspace | Intended working directory | Notes |
|---|---|---|
| `dioscuri-cloud-aws-mlops` | TBD under `terraform/` | AWS MLOps primitives |
| `dioscuri-cloud-azure-mlops` | TBD under `terraform/` | Azure MLOps primitives |
| `dioscuri-cloud-gcp-artifacts` | `terraform/envs/gcp-artifacts` | GCP artifacts scaffold exists |
| `dioscuri-cloud-do-gpu-smoke` | TBD | Bounded GPU smoke only |

## Historical / inactive

| Workspace | Working directory | Notes |
|---|---|---|
| `dioscuri-cloud-vultr-dev` | `infra/terraform/environments/vultr-dev` | Vultr credit closeout; do not configure API keys unless a future issue reactivates Vultr |

## When To Create A New Workspace
Create a new workspace when:
- The provider account/subscription/project boundary differs.
- The lifecycle differs:
  - long-lived primitives (artifact buckets, IAM) vs short-lived experiments.
- The failure domain must be isolated:
  - experimenting with new modules/providers that might require state surgery.
- Different variable sets and secrets are required.

Reuse an existing workspace when:
- You are iterating on the same stack with the same lifecycle and the same boundary.
- The resources are tightly coupled and should be planned/applied together.

## Workspace Variables

Use workspace variables for configuration and secrets. Do not commit secrets to git.

Recommended variable categories:

Common (most workspaces):
- `environment` (e.g. `dev`, `prod`, `exp`) if used.
- `owner` (human-readable owner or team label).
- `repo` = `rmems/Dioscuri-Cloud`.
- `cost_center` or `budget_cap_usd` (where applicable).

Provider-specific (examples):
- AWS:
  - `AWS_REGION`
  - `AWS_ACCESS_KEY_ID` (sensitive)
  - `AWS_SECRET_ACCESS_KEY` (sensitive)
  - Prefer OIDC roles later; keep keys temporary.
- Azure:
  - `ARM_SUBSCRIPTION_ID`
  - `ARM_TENANT_ID`
  - `ARM_CLIENT_ID` (sensitive)
  - `ARM_CLIENT_SECRET` (sensitive)
- GCP:
  - `GOOGLE_PROJECT`
  - `GOOGLE_REGION`
  - `GOOGLE_CREDENTIALS` (sensitive JSON) or workload identity later.
- DigitalOcean:
  - `DIGITALOCEAN_TOKEN` (sensitive)
- Vultr:
  - Inactive after the 2026-05-28 credit closeout.
  - Do not add `VULTR_API_KEY` or create Vultr HCP workspace variables unless a future issue explicitly reactivates Vultr.

Conventions:
- Mark all credentials as sensitive variables in HCP.
- Prefer provider-native workload identity / OIDC where possible (tracked in a later issue).
- Rotate/revoke credentials after experiments.
- Treat retired providers as docs-only until reactivated by a new issue.

## Why GPU Compute Costs Are Not HashiCorp Credits
HashiCorp credits primarily offset control-plane services (e.g., Terraform Cloud/HCP capabilities such as runs, state storage, policy checks, and collaboration features). GPU compute and managed ML services are billed by the cloud provider running the hardware and platform (AWS/Azure/GCP/DO/Vultr/etc.).

Practically:
- Use HCP Terraform to provision and track cloud resources.
- Track provider spend in `cost-ledger.md`.
- Keep “control plane” cost separate from “compute” cost when reviewing burn.
