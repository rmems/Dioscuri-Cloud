# Vultr No-GPU Preflight Run Record

Date: `2026-05-24`

Run ID: `vultr-preflight-20260524-034300z`

Provider: `vultr`

Git commit SHA: `8f78f53fc3649055d959d5c7927226b35729a93c`

GitHub issue: `rmems/Dioscuri-Cloud#37`

Linear issue: `TBD`

## Secret Handling

- `VULTR_API_KEY` present: `yes`, checked with a non-printing environment test
- Secret value printed or committed: `no`
- Raw account output committed: `no`
- Public catalog output committed: `summary only`

## Commands Run

```text
test -n "${VULTR_API_KEY:-}"
curl /v2/account with Authorization: Bearer ${VULTR_API_KEY}
curl /v2/account with Authorization: ${VULTR_API_KEY}
curl /v2/regions
curl /v2/plans
curl /v2/plans?type=vcg
curl /v2/plans?type=vhf
terraform -chdir=infra/terraform/environments/vultr-dev init -backend=false
terraform -chdir=infra/terraform/environments/vultr-dev validate
```

## Public-Safe Results

Account/API access: `blocked`

Account endpoint status with Bearer header: `401`

Account endpoint status with environment-provided Authorization header: `401`

Region list visible: `yes`, public API returned `33` regions

Plans list visible: `yes`, public API returned `151` total plans

Cloud GPU catalog visible: `yes`, public API returned `20` `vcg` plans

VHF catalog visible: `yes`, public API returned `10` `vhf` plans

Selected target region: `ewr` remains a candidate because it appears in the public region list, but account authorization must be fixed before any resource plan can use it.

Terraform validation: `passed`

## Cost

Estimated cost USD: `0`

Actual cost USD: `0`

Cost-ledger reference: `cost-ledger.md` Vultr API preflight row

## Teardown

Resources created: `none`

Teardown evidence: `N/A API-only preflight attempt; authenticated resource audit was blocked by HTTP 401`

Retained resources: `none created by this run`

## Notes

The local `VULTR_API_KEY` variable was detected but did not authenticate to account-scoped Vultr API endpoints. Do not proceed to paid resources until the token is rotated, corrected, or re-exported and #37 is rerun successfully.
