# Cost Ledger

## Credit inventory

| Provider | Credit status | Notes |
|---|---:|---|
| AWS | $200 | Student/lab budget tracking |
| DigitalOcean | $250 | Primary first GPU smoke target |
| HashiCorp | $500 | Terraform/HCP control-plane credits |
| Vultr | $100 | Opportunistic GPU provider |
| Azure | $100–$200 (TBD) | $100 confirmed, possible $200 pending support confirmation |

## Rules

- No long-running GPU jobs without a written estimate.
- No run without teardown confirmation.
- No secrets committed (keys, tokens, DSNs, private paths).
- Record start/end time and estimated cost for every run.

## Run ledger

| run_id | date | provider | region | instance/gpu | start_time_utc | end_time_utc | estimated_cost_usd | teardown_confirmed | notes |
|---|---|---|---|---|---|---|---:|---|---|
| TBD-run-001 | TBD | TBD | TBD | TBD | TBD | TBD | TBD | TBD | Placeholder row only; replace with evidence-backed run record |

## Teardown confirmation template

- run_id: `TBD`
- provider: `TBD`
- resources destroyed: `TBD`
- destroy command or console steps: `TBD`
- destroy completed at (UTC): `TBD`
- residual cost check completed: `TBD`
- verified by: `TBD`
