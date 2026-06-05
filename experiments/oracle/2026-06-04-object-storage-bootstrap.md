# Oracle object storage bootstrap (2026-06-04)

Public-safe run record for first Oracle Cloud resource in `Dioscuri-Cloud`.

## Goal

Create a dev artifact bucket in home region before larger compute experiments.

## Preconditions

- OCI CLI authenticated locally (`oci iam region list` succeeded).
- Home region: `us-phoenix-1`.
- No OCIDs or API key material committed to git.

## Action

```bash
export PATH="$HOME/bin:$PATH"
oci os bucket create \
  --name dioscuri-cloud-dev-artifacts \
  --compartment-id "<tenancy-root-compartment>" \
  --public-access-type NoPublicAccess \
  --storage-tier Standard
```

Operator used tenancy root compartment from local `~/.oci/config` (not recorded here).

## Result

- Status: `succeeded`
- Bucket name: `dioscuri-cloud-dev-artifacts`
- Public access: `NoPublicAccess`
- Storage tier: `Standard`
- Compute instances in tenancy before run: none
- Other buckets before run: none

## Cost

- Estimated: `$0` until objects are stored (empty bucket; monitor in OCI Cost Analysis)
- Actual: `TBD`
- Credit pool: Oracle `$300` free trial (`docs/credits/inventory.md`)

## Teardown

- Retained for artifact experiments until a follow-up issue schedules teardown.
- Teardown evidence: `TBD` when bucket is deleted.

## Next steps

- Mirror OCI auth into HCP workspace `dioscuri-cloud-oracle-dev` sensitive variables.
- Add Terraform `oci` provider wiring in `terraform/envs/oracle-dev`.
- IBM bootstrap blocked until `ibmcloud login` or `IBMCLOUD_API_KEY` is available in the automation shell.
