# Cloud Credit Usage Policy

This policy exists to keep cloud spend deliberate, reproducible, and auditable.

## Scope
Applies to any cloud resource that can incur cost (compute, storage, managed services, networking, monitoring, etc.).

## Allowed Uses
- Reproducible experiments tied to a concrete repo outcome (code, benchmark, write-up, or runbook update).
- Learning or validation work that results in a documented artifact in this repo.

Not allowed:
- Open-ended exploration without tracking.
- Long-lived resources without explicit justification and an owner.

## Tracking Requirements (Mandatory)
- A Linear issue is required for any spend. The issue must describe:
  - Purpose and expected output.
  - Estimated cost and duration.
  - Teardown plan.
- A PR is required for changes that:
  - Add/modify infrastructure (Terraform, scripts) or otherwise create billable resources.
  - Add results (benchmarks, reports, dashboards) produced by a paid run.
- `cost-ledger.md` must be updated in the same PR that creates or changes the billable resources, or in the results PR if no prior ledger entry exists for that run.

## Budget Guardrails
- Set an explicit estimated cost in the Linear issue before creating resources.
- Default spend cap is the provider-specific cap listed in `docs/credits/inventory.md` (cap period varies by provider—per-experiment for most, per-month aggregate for GCP). For providers not listed there, the default cap is $10 per experiment.
- If an experiment needs more than the default cap, document the reason and approval in the Linear issue.

## Resource Hygiene
- Prefer smallest viable instances and shortest runtimes.
- Use clear naming conventions so resources are attributable:
  - Include repo name, experiment slug, and date, e.g. `dioscuri-cloud-exp-<slug>-2026-05-22`.
- Use tags/labels to include:
  - `owner`, `linear`, `pr`, `teardown_by`.

## Teardown Requirements
- Teardown must be planned up-front and executed promptly after the experiment completes. For providers with explicit teardown deadlines in the Budget caps / guardrails column of `docs/credits/inventory.md`, follow those deadlines (e.g., DigitalOcean within 24 h of completion, Azure same day when possible).
- Teardown evidence is required in `cost-ledger.md`:
  - Provider console link showing resource deleted, or
  - CLI output snippet confirming deletion, or
  - Audit log link, or
  - Screenshot link.
- If teardown has not yet occurred when the ledger row is first added (e.g. the infra PR merges before the experiment runs), use `TBD` and update the cell in a follow-up PR or commit once teardown is complete.

## Cost Reconciliation
- Record estimated cost at time of creation.
- Update `Actual cost (USD)` once billing data is available.
- If actual cost materially exceeds estimate, add a short postmortem note in the ledger row.

## Security
- No long-lived credentials committed to the repo.
- Use least privilege roles/service accounts.
- Rotate/revoke temporary keys after teardown.
