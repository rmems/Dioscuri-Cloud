# IBM Cloud account preflight (2026-06-05)

Public-safe run record after `ibmcloud login` succeeded.

## CLI status

- `ibmcloud account show`: ACTIVE PAYG account
- Target region: `us-south`
- COS plugin: installed (`cloud-object-storage` 1.11.0)

## Actions

- Created resource group: `dioscuri-cloud`
- Targeted: `ibmcloud target -g dioscuri-cloud -r us-south`

## Not created yet

- COS buckets
- Service IDs / IAM policies
- watsonx or compute resources

## Next steps

- Create COS bucket for artifacts (add `cost-ledger.md` row first).
- Add `IBMCLOUD_*` variables to HCP workspace `dioscuri-cloud-ibm-dev` when HCP org exists.
- Implement IBM provider block in `terraform/envs/ibm-dev`.
