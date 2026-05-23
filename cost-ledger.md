
# Cost Ledger

Every cloud experiment/change that can incur cost must be recorded here.

Rules:
- Add (or update) a row in the same PR that creates/changes billable resources.
- Include both estimated and actual cost when available. If actual cost is not yet known, use `TBD` and reconcile later.
- Teardown evidence must be linkable: provider console link showing resource deleted, CLI output snippet confirming deletion, audit log link, or screenshot link. If teardown has not yet occurred when the row is first added, use `TBD` and update the cell in a follow-up PR or commit once teardown is complete.

| Date (YYYY-MM-DD) | Provider | Linear issue | PR | Resource(s) | Purpose | Est. cost (USD) | Actual cost (USD) | Teardown evidence | Notes |
|---|---|---|---|---|---|---:|---:|---|---|
| 2026-05-22 | TEMPLATE | TBD | TBD | e.g. `do:droplet:gpu-1` | e.g. Reproducible benchmark run | 0 | TBD | Link to teardown proof | Replace this row; do not leave template entries after first real use |
