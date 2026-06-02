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

## Proposed Workspace Set

| Workspace | Ownership boundary | What it manages |
|---|---|---|
| `dioscuri-cloud-hcp-core` | HCP-only / control plane | Terraform Cloud/HCP settings, shared policy hooks, global conventions |
| `dioscuri-cloud-aws-mlops` | AWS account boundary | IAM/ECR/S3 budgets/alerts and MLOps primitives (no GPU jobs themselves) |
| `dioscuri-cloud-azure-mlops` | Azure subscription boundary | Resource groups, Key Vault, storage, budgets/alerts |
| `dioscuri-cloud-gcp-artifacts` | GCP project boundary | Buckets/Artifact Registry/Service Accounts for artifacts |
| `dioscuri-cloud-do-gpu-smoke` | DO project boundary | Minimal infra needed for a repeatable GPU smoke test |
| `dioscuri-cloud-ibm-dev` | IBM account boundary | Dev/testing infrastructure only (short-lived by default) |
| `dioscuri-cloud-vultr-dev` | Vultr account boundary | Safe metadata scaffold and short-lived Vultr smoke-test planning only |

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
