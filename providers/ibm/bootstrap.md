# IBM Cloud Bootstrap (Terraform)

This runbook bootstraps IBM Cloud for this lab using Terraform without committing credentials.

Primary goal: get storage + IAM working safely before any compute.

## Safety Rules

- Do not commit credentials, state files, or `.terraform/` directories.
- The first paid resources should be:
  - Object storage (COS)
  - Service ID + access policies
- Do not create GPU instances at bootstrap stage.
- Before creating any paid resource, add a row to `cost-ledger.md` (estimate + teardown plan).

## Prerequisites

1. IBM Cloud account
- Create or sign in: https://cloud.ibm.com/

2. Pick a region
- Choose one region and stick to it for the initial bootstrap.

3. Create/choose a resource group
- IBM Cloud console: Manage -> Account -> Resource groups.
- Use a dedicated group for this repo, e.g. `dioscuri-cloud`.

4. Create an IBM Cloud API key
- IBM Cloud console: Manage -> Access (IAM) -> API keys.
- Create a key scoped for this lab.
- Treat it like a password.

## HCP Terraform Workspace Variables (Recommended)

If using HCP Terraform VCS integration, configure these as workspace variables (not files):

- `IBMCLOUD_API_KEY` (sensitive)
- `IBMCLOUD_REGION`
- `IBMCLOUD_RESOURCE_GROUP`

Optional but recommended:
- `owner`
- `environment` (e.g. `dev`)
- `budget_cap_usd`

Workspace naming convention: see `docs/hcp/workspaces.md`.

## Minimal Provider Example (No Hardcoded Secrets)

In Terraform, reference credentials via variables:

```hcl
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.70"
    }
  }
}

variable "ibmcloud_api_key" {
  type      = string
  sensitive = true
}

variable "ibmcloud_region" {
  type = string
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.ibmcloud_region
}
```

In HCP Terraform, map variables:
- `ibmcloud_api_key` <- `IBMCLOUD_API_KEY`
- `ibmcloud_region` <- `IBMCLOUD_REGION`

Do not add `.tfvars` with secrets to the repo.

## Recommended First Targets

1. COS bucket (artifact storage)
- Create a bucket/container for experiment artifacts.
- Enable versioning where possible.

2. Service ID (principal) + policies
- Create a Service ID for artifact access.
- Attach the minimum policies needed for the bucket.

3. Small CPU runner (only after storage + IAM works)
- If you need compute, start with the smallest CPU instance and short runtime.
- Track spend in `cost-ledger.md` and teardown immediately after testing.

## Teardown Checklist

- Delete any compute instances.
- Delete load balancers, public IPs, gateways, and volumes.
- Remove temporary IAM keys/service credentials.
- Confirm deletions in the console and link evidence in `cost-ledger.md`.
