# Cloud Credit Inventory

This file is the source of truth for free credits available to this repo and their guardrails.

Notes:
- Do not guess expiration dates. If unknown, set `TBD` and update after verifying in the provider/program portal.
- Keep amounts in USD.
- Dates are recorded as `YYYY-MM-DD`.

| Provider | Program / credit type | Amount (USD) | Expiration date | Primary intended uses | Budget caps / guardrails | Notes |
|---|---|---:|---|---|---|---|
| DigitalOcean | Student credits | 205 | 2027-04-28 | Small CPU instances, managed DB trials, reproducible deployments | Default spend cap: $20/experiment; teardown within 24h of completion | Prefer smallest droplet that meets requirements |
| AWS | Student credits | 200 | 2027-03-15 | Short-lived GPU/CPU experiments, storage for datasets (minimal) | Default spend cap: $25/experiment; no unmanaged long-lived resources | Use budgets/alerts where available |
| Azure | Student credits | 100 | 2027-02-12 | Short-lived experiments, minimal infra validation | Default spend cap: $15/experiment; teardown same day when possible | Use resource groups per experiment |
| HashiCorp | Student credits | 500 | TBD | Terraform Cloud runs, learning labs, reproducible infra experiments | Cap per experiment: $25 unless approved in Linear | Expiration estimate mentioned in issue comment; confirm exact date in portal |
| Vultr | Account credit | 250 | 2026-05-28 | Opportunistic GPU tests and short-lived compute experiments | Default spend cap: $25/experiment; teardown same day unless documented | Credit screenshot in issue notes; update if Vultr changes expiration |
| GCP | Google AI Pro monthly credit | 10 / month | Monthly | Light experiments only (small inference, minimal storage) | Default spend cap: $10/month; track each run in ledger | Recurs monthly while subscription active |
