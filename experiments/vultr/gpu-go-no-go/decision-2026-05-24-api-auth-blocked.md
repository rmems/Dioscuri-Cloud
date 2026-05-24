# Vultr GPU/Inference Go/No-Go Decision

Date: `2026-05-24`

Decision ID: `vultr-gpu-decision-20260524-034300z`

Git commit SHA: `8f78f53fc3649055d959d5c7927226b35729a93c`

GitHub issue: `rmems/Dioscuri-Cloud#38`

Linear issue: `TBD`

## Checks Run

```text
curl /v2/regions
curl /v2/plans
curl /v2/plans?type=vcg
curl /v2/plans?type=vhf
curl /v2/account with redacted auth handling
```

## Availability Summary

Candidate regions: `ewr`, `ord`, `atl`, `lhr`, `fra`, `sjc`, `nrt`, `sgp`, and `blr` appear in the smallest public `vcg` plan's location list.

Candidate SKU/plan IDs: `vcg-a16-2c-8g-2vram` and `vcg-a40-1c-5g-2vram` are the smallest public GPU candidates observed.

GPU or inference target type: `NVIDIA_A16` or `NVIDIA_A40` Cloud GPU plans from the public catalog.

Hourly price: `vcg-a16-2c-8g-2vram` is listed at `$0.059/hour`; `vcg-a40-1c-5g-2vram` is listed at `$0.075/hour`.

Estimated max runtime: `1 hour` for a future smoke test unless explicitly approved otherwise.

Estimated max cost: `< $1` for the smallest one-hour GPU check before taxes/ancillary charges; hard cap remains `$25`.

Quota/stock/access status: `blocked`; authenticated account checks returned HTTP `401`, so quota, stock, and account eligibility were not verified.

## Decision

Outcome: `no-go`

Selected target if go: `none`

Runtime cap if go: `N/A`

Cost cap if go: `N/A`

Teardown path if go: `N/A`

Fallback if no-go or blocked: rotate or correct the local Vultr API token, rerun #37 account/API preflight, then rerun this go/no-go check before approving #39. If auth cannot be fixed before `2026-05-28`, move GPU smoke work to another provider and keep Vultr as fallback-only.

## Public-Safe Evidence

Only HTTP statuses and public plan metadata were recorded. No token value, token prefix, account details, private billing data, or provider screenshots were committed.
