# CLAUDE.md

Claude-specific notes only. There is no `AGENTS.md` in this repo; goals, provider strategy, run discipline, and the
Agoge boundary are in `README.md`, `docs/repository-structure.md`, and `docs/training-setup.md`, so they are not
repeated here. This is planned cloud infrastructure: mostly docs, runbooks, and Terraform scaffolds.

## Commands

Run from the repo root. "Verified" means it ran successfully here (Linux, no cloud credentials, no backend).
CI pins Terraform 1.10.5 (`terraform-validate.yml`); I ran the same 1.10.5 release.

| Command | Status |
|---|---|
| `terraform fmt -check -recursive terraform` and `... infra/terraform` | verified (Terraform 1.10.5) |
| `terraform init -backend=false` + `validate` on `terraform/modules/artifact_bucket`, `terraform/modules/service_account`, `infra/terraform/modules/onboarding_baseline` | verified (on throwaway copies; these need no providers) |
| `python3 tests/ci/test_gitlab_ci.py` | verified (22 tests, Python 3.13 with PyYAML; pytest is not installed here) |
| `validate` / `test` on `training_execution`, `training_node`, `envs/aws-training`, `envs/oracle-dev`, `vultr-dev` | not run (`init` downloads providers; CI does it with `-backend=false`) |
| `validate` on `envs/ibm-dev`, `envs/gcp-artifacts`, `infra/terraform/environments/dev` | not run (same reason; CI runs most of them) |
| `terraform plan` / `apply` / `destroy`, any HCP or cloud CLI | not run (needs cloud credentials; never run these from an agent session) |
| `scripts/training-bootstrap.sh`, `scripts/hcp/bootstrap-workspaces.sh` | not run (need AWS and HCP credentials; the AWS GPU check dispatches `ssm:SendCommand`) |
| `.github/workflows/azure-oidc-preflight.yml` | not run (manual `workflow_dispatch`, needs Azure OIDC secrets) |
| `docker build training/docker` | not run (Docker and a GPU host not available here) |

CI: `terraform-validate.yml` runs fmt, then validate (and `terraform test` where a `tests/` dir exists) with
`-backend=false`. `.gitlab-ci.yml` is a secondary mirror plus a Duo review job. Run `terraform fmt -recursive` on
the dirs you touched before committing; CI fails on fmt.

## Architecture map

- `terraform/modules/*`, `terraform/envs/*`: general modules and per-provider env roots (`aws-training` is the primary path).
- `infra/terraform/`: separate scaffolds (`environments/dev`, `vultr-dev`, `modules/onboarding_baseline`) that may map to HCP workspaces.
- `providers/<name>/`: public-safe provider runbooks. `experiments/`: run records, templates, closeouts.
- `docs/`: strategy, credits, HCP notes, `docs/schemas/experiment-manifest.md`, `docs/issues/` (canonical issue bodies).
- `cost-ledger.md`: running credit-usage estimate. `training/docker/`: CUDA training image. `scripts/`: bootstrap and issue helpers.
- `.agents/setup`, `.cursor/install.sh`: agent-environment bootstrap (Terraform 1.10.5 plus `init -backend=false`), not build steps.

## Invariants and non-goals (from README and `docs/repository-structure.md`)

- Cloud operations only. Training code, eval, checkpoints, and HF release tooling belong to `rmems/agoge-forger`; no cloud-infra trees go there.
- Custom CUDA and GPU kernel work belongs to `rmems/blackwell-kernel-lab`, not here.
- Never commit secrets, API keys, DSNs, local checkpoint paths, or model weights; `.gitignore` does not cover them, so check `git status` yourself. Only `*.tfvars`, `*.tfstate` and `.terraform/` are gitignored. Use env vars or HCP sensitive variables; runbooks stay public-safe.
- No long-running GPU job without a cost estimate, a GitHub issue, and a teardown plan. New billable resources need a `cost-ledger.md` row.
- Every billable run records the fields in `docs/schemas/experiment-manifest.md`. Do not invent readiness numbers or costs.
- `azure-oidc-preflight.yml` stays manual-only and read-only: no push/PR triggers, no resource-creating steps.
- Commit `.terraform.lock.hcl` where one exists; pin third-party GitHub Actions to commit SHAs (most are; `actions/checkout` uses `@v4`).

## Gotchas

- Never run `terraform apply`/`plan` against a real backend, cloud CLIs with credentials, or any publish command.
- `terraform init` without `-backend=false` can touch remote state; always pass it for local checks.
- Module `required_version` is `>= 1.3.0` or `>= 1.7.0` depending on the dir; CI uses 1.10.5.
- Source files have no SPDX header convention; do not add one. There is no publish or exclude list to update.
- `.claude/` is not gitignored (`.cursor/*`, `.kilo/`, `.kiro/` are); do not commit local agent state there.
- Edit only what the task needs.
