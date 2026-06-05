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
| HashiCorp | Student credits | 500 | 2026-11-10 | Terraform Cloud runs, learning labs, reproducible infra experiments | Cap per experiment: $25 unless approved in Linear | Expiration confirmed by repo owner 2026-06-05 |
| Vultr | Account credit | 250 | 2026-05-28 | Completed serverless inference sprint; inactive for near-term execution | Closed out at `$237.31` consumed, `$12.69` expired, `$0.00` owed | Keep records only; do not upload/configure Vultr API keys unless a future issue reactivates provider use |
| IBM Cloud | Cloud credit | 200 | 2026-06-28 | watsonx, research-agent prototypes, synthetic data pipeline, object storage evaluation; SAAQ artifact mirror + CPU validation jobs | Default spend cap: $20/experiment; URGENT - expires 2026-06-28 | Expiration confirmed by repo owner 2026-06-05; watsonx free trial activated; avoid business-email-gated services unless access is confirmed |
| Oracle Cloud | Free trial | 300 | 2026-06-28 | Persistent services, MCP hosting, telemetry ingestion, object storage, vector/RAG backend; canonical SAAQ artifact store + CPU validation host | Default spend cap: $20/experiment; URGENT - expires 2026-06-28; retained resources require monthly cost and review date | Expiration confirmed by repo owner 2026-06-05; record region, quotas, and free-tier eligibility before creating resources |
| GCP | Google AI Pro monthly credit | 10 / month | Monthly | Light experiments only (small inference, minimal storage) | Default spend cap: $10/month; track each run in ledger | Recurs monthly while subscription active |
