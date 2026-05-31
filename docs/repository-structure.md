# Repository Structure

This repository is the cloud operations layer for Dioscuri labs. It keeps provider decisions, runbooks, experiment records, cost notes, and reusable Terraform scaffolds separate from the SAAQ runtime implementation in `rmems/corinth-canal`.

## Top-Level Layout

| Path | Purpose | Commit Rules |
|---|---|---|
| `providers/` | Provider-specific setup, onboarding, runbooks, and teardown notes. | Public-safe notes only; no credentials, private account IDs, or screenshots with billing identifiers. |
| `experiments/` | Run records, closeout reports, queue summaries, and checked-in templates. | Small text artifacts only; no model weights, generated outputs, local state, or large logs. |
| `docs/` | Cross-provider strategy, schemas, certification maps, comparison docs, and reusable runbooks. | Keep docs provider-neutral unless a provider path is more appropriate. |
| `terraform/` | General Terraform notes, modules, and provider layout. | No state files, `.terraform/`, `.tfvars`, or embedded secrets. |
| `infra/terraform/` | Environment-specific Terraform scaffolds that may map to HCP Terraform workspaces. | Metadata-only scaffolds are allowed before credentials are available. Resource creation requires a cost-ledger row. |
| `cost-ledger.md` | Cost estimates, actual spend, and teardown evidence. | Update in the same PR that adds or changes billable cloud work. |

## Lab Areas

| Lab Area | Primary Paths | Notes |
|---|---|---|
| Provider evaluation | `docs/provider-comparison.md`, `providers/` | Compares provider fit before creating resources. |
| Certification alignment | `docs/certification-lab-map.md`, `providers/` | Maps labs to provider certification and learning tracks. |
| Artifact storage | `docs/artifact-storage-plan.md`, `docs/schemas/` | Defines what can be stored and where before implementation. |
| Cloud credit operations | `docs/credits/`, `cost-ledger.md`, `docs/cloud-credit-strategy.md` | Tracks credits, caps, spend, and provider roles. |
| Experiment execution | `experiments/`, `docs/runbooks/` | Records bounded execution plans and outcomes. |

## Security Boundaries

- Do not commit API keys, token names, token prefixes, local account IDs, private billing identifiers, local absolute paths, model weights, generated model artifacts, Terraform state, or provider CLI profiles.
- Use environment variables, HCP Terraform sensitive variables, or provider consoles for secrets.
- Record public-safe status values such as `blocked`, `skipped`, `succeeded`, HTTP status classes, cost totals, and teardown summaries.

## Adding New Work

1. Add or update the provider note under `providers/<provider>/`.
2. Add an experiment run record under `experiments/<provider>/` if execution occurs.
3. Update `cost-ledger.md` for any billable resource or credit reconciliation.
4. Add cross-provider planning updates under `docs/` when the decision affects more than one provider.
