# AGENTS.md

Guidance for coding agents (Amp, Codex, Cursor, Claude Code, and others) working in this repository.

## Purpose

Dioscuri-Cloud is the cloud operations layer for AI model training on student/free cloud credits
(see `README.md`): object storage, CUDA training images, GPU nodes, managed training jobs
(SageMaker / Azure ML), cost tracking, and an HCP Terraform control plane. The training
implementation lives in `rmems/agoge-forger`; this repo only orchestrates it. Keep train/eval code
out of this repo, and keep cloud-infra trees out of Agoge.

## Layout

| Path | Contents |
|------|----------|
| `terraform/modules/`, `terraform/envs/` | Terraform modules and per-provider environments (`aws-training`, `oracle-dev`, `ibm-dev`, `gcp-artifacts`) |
| `infra/terraform/modules/`, `infra/terraform/environments/` | Onboarding baseline module; `dev`, `vultr-dev` environments |
| `providers/` | Per-provider notes (aws, azure, digitalocean, ibm, oracle, vultr) |
| `training/docker/` | CUDA training image |
| `experiments/` | Provider experiments and smoke setups |
| `scripts/` | `training-bootstrap.sh`, `hcp/`, issue helpers |
| `docs/`, `cost-ledger.md` | Runbooks, schemas, training docs; spend ledger |
| `tests/ci/` | CI test assets |

## Toolchain

- Terraform **1.10.5** (`hashicorp/setup-terraform` in `terraform-validate.yml`; `TF_VERSION` in `.gitlab-ci.yml`).
- No cloud credentials are needed to validate (`init -backend=false`).
- No GPU needed locally. `scripts/training-bootstrap.sh` builds the CUDA training image and runs
  its `--help` and python3/torch smokes with `docker run`; those smokes don't need a GPU
  (`training/docker/README.md`).

## Commands (from `.github/workflows/terraform-validate.yml`)

```bash
terraform fmt -check -recursive terraform
terraform fmt -check -recursive infra/terraform

# For each module in terraform/modules/* and infra/terraform/modules/*,
# and each environment (terraform/envs/*, infra/terraform/environments/*):
terraform -chdir=<dir> init -backend=false
terraform -chdir=<dir> validate
terraform -chdir=<dir> test   # modules with a tests/ dir, plus terraform/envs/oracle-dev and aws-training
```

GitHub Actions is the primary merge gate. `.gitlab-ci.yml` mirrors fmt/validate as secondary CI.
`azure-oidc-preflight.yml` is a manual-dispatch Azure OIDC check that needs
`AZURE_CLIENT_ID`/`AZURE_TENANT_ID`/`AZURE_SUBSCRIPTION_ID`. It isn't part of build/test.

## Conventions visible in the repo

- CI only runs `fmt`, `init -backend=false`, `validate` and `test`. Nothing in CI plans or applies.
  Real runs spend cloud credits, which are tracked in `cost-ledger.md`.
- README non-goals: no secrets, API keys, DSNs, local checkpoint paths or model weights committed,
  and no long-running GPU jobs without a cost estimate, GitHub issue and teardown plan.
- Don't commit state, `*.tfvars`, `.terraform/` or `.terraformrc` (all gitignored). Do commit
  `.terraform.lock.hcl` where one already exists.
- Run `terraform fmt` before committing. CI fails on unformatted HCL.
- Commit subjects follow Conventional Commits with scopes (`feat(training):`, `docs(aws):`,
  `fix(oracle-dev):`) and issue/PR numbers.
