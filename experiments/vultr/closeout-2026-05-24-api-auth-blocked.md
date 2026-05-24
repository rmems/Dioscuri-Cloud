# Vultr Credit Closeout Record

Date: `2026-05-24`

Provider: `vultr`

Credit deadline: `2026-05-28`

Git commit SHA: `8f78f53fc3649055d959d5c7927226b35729a93c`

GitHub issues: `#35`, `#36`, `#37`, `#38`, `#39`, `#40`

Linear issue: `TBD`

## Final Execution Status

Bootstrap runbook completed: `yes, in this PR`

Terraform scaffold completed: `yes, in this PR; validation passed with -backend=false`

No-GPU preflight completed: `blocked; local VULTR_API_KEY was present but account-scoped API calls returned HTTP 401`

GPU/inference go-no-go completed: `blocked; public GPU catalog is visible, but account quota/stock/access could not be verified`

GPU/inference smoke completed: `no; not approved because #38 is blocked`

## Resource Audit

Authenticated resource-audit endpoints returned HTTP `401`, so this closeout cannot prove the state of pre-existing Vultr resources in the account.

Resources created by this PR/run: `none`

Cloud compute instances: `not verified; authenticated endpoint returned 401`

GPU instances: `not verified; authenticated endpoint returned 401`

Inference endpoints: `not verified; no inference resource was created by this PR`

Block storage volumes: `not verified; authenticated endpoint returned 401`

Object storage buckets: `not verified; authenticated endpoint returned 401`

Snapshots/images: `not verified; authenticated endpoint returned 401`

Reserved IPs: `not verified; authenticated endpoint returned 401`

Load balancers: `not verified; authenticated endpoint returned 401`

Firewalls/network attachments: `not verified; authenticated endpoint returned 401`

## Cost Reconciliation

Cost ledger rows updated: `yes, for the API-only blocked preflight attempt`

Estimated total Vultr cost USD: `0`

Actual total Vultr cost USD: `0 for resources created by this PR; no paid resources were created`

Actual-cost follow-up path: after token correction, rerun the closeout audit and verify account billing/resource pages before `2026-05-28`.

## API Key Cleanup

Temporary key decision: `rotate or re-export required; current local value did not authenticate`

HCP variable cleanup: `N/A; no HCP run was executed by this PR`

## Final Recommendation

Recommendation: `fallback-only`

Rationale: public GPU catalog data shows cheap candidate plans, but account authentication failed and quota/stock/access could not be verified. Do not use Vultr for paid smoke tests until #37 and #38 pass with an authenticated token.

## Evidence

Public-safe evidence recorded:
- account endpoint returned HTTP `401`
- authenticated resource-audit endpoints returned HTTP `401`
- public regions endpoint returned `33` regions
- public plans endpoint returned `151` plans
- public `vcg` plans endpoint returned `20` Cloud GPU plans
- public `vhf` plans endpoint returned `10` plans
