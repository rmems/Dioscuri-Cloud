
# Cost Ledger

Every cloud experiment/change that can incur cost must be recorded here.

Rules:
- Add (or update) a row in the same PR that creates/changes billable resources.
- Include both estimated and actual cost when available. If actual cost is not yet known, use `TBD` and reconcile later.
- Teardown evidence must be linkable: PR comment, provider console link, audit log link, or a short snippet captured in the PR description.

| Date (YYYY-MM-DD) | Provider | Linear issue | PR | Resource(s) | Purpose | Est. cost (USD) | Actual cost (USD) | Teardown evidence | Notes |
|---|---|---|---|---|---|---:|---:|---|---|
| 2026-05-22 | TEMPLATE | TBD | TBD | e.g. `do:droplet:gpu-1` | e.g. Reproducible benchmark run | 0 | TBD | Link to teardown proof | Replace this row; do not leave template entries after first real use |
