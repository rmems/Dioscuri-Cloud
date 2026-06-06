# Oracle Cloud Bootstrap (Terraform)

This runbook bootstraps Oracle Cloud Infrastructure (OCI) for this lab without committing credentials.

Primary goal: verify CLI auth and compartment/region choices before any billable resources.

## Safety Rules

- Do not commit credentials, state files, or `.terraform/` directories.
- Do not commit tenancy OCIDs, user OCIDs, fingerprints, private keys, or `~/.oci/config`.
- Before creating any paid resource, add a row to `cost-ledger.md` (estimate + teardown plan).
- Favor smallest shapes and short-lived experiments per `docs/cloud-credit-strategy.md`.

## Prerequisites

1. Oracle Cloud account with free trial credits (see `docs/credits/inventory.md`).
2. Pick one home region and record it in a public-safe experiment run record (region name only).
3. Create or choose a compartment for `Dioscuri-Cloud` dev work.
4. Create an API signing key in the OCI console (User Settings -> API Keys).

## OCI CLI setup (local)

Install the OCI CLI per Oracle documentation, then:

```bash
oci --version
oci setup config
oci iam region list
```

Config and private key live under `~/.oci/` only. Do not add them to this repository.

## HCP Terraform workspace variables

Configure on workspace `dioscuri-cloud-oracle-dev` (not in git). See `docs/hcp/provider-variable-map.md` for the full map.

Required when provider blocks are added (names only here):

- `OCI_TENANCY_OCID` (sensitive)
- `OCI_USER_OCID` (sensitive)
- `OCI_FINGERPRINT` (sensitive)
- `OCI_PRIVATE_KEY` (sensitive)
- `OCI_REGION`
- `OCI_COMPARTMENT_OCID` (sensitive)

Optional: `owner`, `environment`, `budget_cap_usd`.

## Terraform layout

- Environment stack: `terraform/envs/oracle-dev`
- HCP workspace: `dioscuri-cloud-oracle-dev`
- Provider implementation is deferred; skeleton composes shared modules only.

## Import existing artifact bucket (before first OCI apply)

Bucket `dioscuri-cloud-dev-artifacts` was created manually via OCI CLI before Terraform provider wiring (see `experiments/oracle/2026-06-04-object-storage-bootstrap.md` and `cost-ledger.md`). The default in `terraform/envs/oracle-dev/variables.tf` matches that live bucket so speculative plans succeed today.

When the OCI provider block is added (#48), **import** the bucket into Terraform state before the first apply to avoid a create conflict:

```bash
# Example — adjust resource address and import ID once provider resources exist
terraform -chdir=terraform/envs/oracle-dev import \
  '<oci_object_storage_bucket_resource_address>' \
  '<namespace>/<bucket_name>'
```

Record the import run in a public-safe experiment note; do not commit OCIDs or namespace values to git.

## Recommended first targets (after Issue #46)

1. Object Storage bucket for experiment artifacts (minimal size, clear naming).
2. Smallest compute instance or free-tier shape for a bounded smoke test.
3. Teardown with evidence linked from `cost-ledger.md`.

## Teardown checklist

- Terminate compute, load balancers, and block volumes.
- Delete object storage buckets used for experiments.
- Revoke API keys no longer needed.
- Confirm deletions in the console; link public-safe evidence in `cost-ledger.md`.
