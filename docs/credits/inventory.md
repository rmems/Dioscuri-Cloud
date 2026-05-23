# Cloud Credit Inventory

This file is the source of truth for free credits available to this repo and their guardrails.

Notes:
- Do not guess expiration dates. If unknown, set `TBD` and update after verifying in the provider/program portal.
- Keep amounts in USD.

| Provider | Program / credit type | Amount (USD) | Expiration date | Primary intended uses | Budget caps / guardrails | Notes |
|---|---|---:|---|---|---|---|
| HashiCorp | Student credits | 500 | TBD | Terraform Cloud runs, learning labs, reproducible infra experiments | Cap per experiment: $25 unless approved in Linear | Update expiration after checking program portal |
| DigitalOcean | Student credits | 205 | TBD | Small CPU instances, managed DB trials, reproducible deployments | Default spend cap: $20/experiment; teardown within 24h of completion | Prefer smallest droplet that meets requirements |
| AWS | Student credits | 200 | TBD | Short-lived GPU/CPU experiments, storage for datasets (minimal) | Default spend cap: $25/experiment; no unmanaged long-lived resources | Use budgets/alerts where available |
| Azure | Student credits | 100 | TBD | Short-lived experiments, minimal infra validation | Default spend cap: $15/experiment; teardown same day when possible | Use resource groups per experiment |
