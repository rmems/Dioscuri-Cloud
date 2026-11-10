# AGENTS.md

Guidance for coding agents (Amp, Codex, Cursor, Claude Code, and others) working in this repository.

## Purpose

Dioscuri-Cloud is the cloud operations layer for AI model training on student/free cloud credits
(see `README.md`): object storage, CUDA training images, GPU nodes, managed training jobs
(SageMaker / Azure ML), cost tracking, and an HCP Terraform control plane. The training
implementation lives in `rmems/agoge-forger`; this repo only orchestrates it. Keep train/eval code
out of this repo, and keep cloud-infra trees out of Agoge. Custom CUDA and GPU kernel work belongs
to `rmems/blackwell-kernel-lab`, not here.

This file is the shared guidance for all agents. `CLAUDE.md` keeps Claude-session verification notes
(what ran locally on a given machine); it repeats a few safety rules for convenience. Prefer this
file when the two differ.

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
- For training-image-only changes, run a local build and both no-GPU container smokes directly
  (no HCP/AWS credentials required):

  ```bash
  docker build -t dioscuri-cloud-training:local training/docker
  docker run --rm dioscuri-cloud-training:local --help
  docker run --rm dioscuri-cloud-training:local \
    python3 -c "import torch; print(torch.__version__, torch.cuda.is_available())"
  ```

  A GPU-backed run is optional and separate; the smokes above execute the image without a GPU.
  `training/docker/README.md` documents GPU-backed commands. `scripts/training-bootstrap.sh`
  performs the same Docker smokes only after HCP/AWS/S3 operator preflight (and may dispatch SSM
  when configured); use it for full bootstrap, not as the minimal image-only check.

## Commands (from `.github/workflows/terraform-validate.yml`)

```bash
terraform fmt -check -recursive terraform
terraform fmt -check -recursive infra/terraform

# For each module in terraform/modules/*:
terraform -chdir=<dir> init -backend=false
terraform -chdir=<dir> validate
terraform -chdir=<dir> test   # only when the module has a tests/ directory

# For each module in infra/terraform/modules/* (no test step):
terraform -chdir=<dir> init -backend=false
terraform -chdir=<dir> validate

# Environments validated by this workflow:
terraform -chdir=infra/terraform/environments/dev init -backend=false
terraform -chdir=infra/terraform/environments/dev validate
terraform -chdir=infra/terraform/environments/vultr-dev init -backend=false
terraform -chdir=infra/terraform/environments/vultr-dev validate
terraform -chdir=terraform/envs/oracle-dev init -backend=false
terraform -chdir=terraform/envs/oracle-dev validate
terraform -chdir=terraform/envs/oracle-dev test
terraform -chdir=terraform/envs/ibm-dev init -backend=false
terraform -chdir=terraform/envs/ibm-dev validate
terraform -chdir=terraform/envs/aws-training init -backend=false
terraform -chdir=terraform/envs/aws-training validate
terraform -chdir=terraform/envs/aws-training test
```

The workflow formats `terraform/envs/gcp-artifacts` through the recursive fmt check but does not
initialize, validate, or test it.

GitHub Actions is the primary merge gate. `.gitlab-ci.yml` is a partial secondary mirror: it runs
the same formatting checks and validates the modules plus `dev`, `vultr-dev`, `oracle-dev`, and
`ibm-dev`, but omits `aws-training` and all Terraform tests.
`azure-oidc-preflight.yml` is a manual-dispatch Azure OIDC check that needs
`AZURE_CLIENT_ID`/`AZURE_TENANT_ID`/`AZURE_SUBSCRIPTION_ID`. It isn't part of build/test.

`tests/ci/test_gitlab_ci.py` checks `.gitlab-ci.yml` (including the Duo review job). No CI
workflow runs it, so run it yourself whenever you change `.gitlab-ci.yml` (needs PyYAML):

```bash
python3 tests/ci/test_gitlab_ci.py
```

## Conventions visible in the repo

- GitHub `terraform-validate.yml` and GitLab's `validate` stage run Terraform `fmt`,
  `init -backend=false`, `validate`, and (on GitHub only, for selected roots) `terraform test`.
  They do not run standalone `plan`, `apply`, or `destroy` against real backends; test fixtures may
  still invoke mocked `plan`/`apply` inside `terraform test` run blocks. GitLab also exposes a
  manual `gitlab-duo-review` job (see `.gitlab-ci.yml`). Billable cloud work is tracked in
  `cost-ledger.md`.
- Agent sessions stick to validation-only Terraform (`init -backend=false`, `validate`, `test`) and
  skip `plan`/`apply`/`destroy`, credential-backed HCP or cloud CLIs, and publish commands (see
  `CLAUDE.md` Gotchas).
- README non-goals: no secrets, API keys, DSNs, local checkpoint paths or model weights committed,
  and no long-running GPU jobs without a cost estimate, GitHub issue and teardown plan.
- Don't commit state, `*.tfvars`, `.terraform/` or `.terraformrc` (all gitignored). Do commit
  `.terraform.lock.hcl` where one already exists.
- `.claude/` is not gitignored (`.cursor/*`, `.kilo/` and `.kiro/` are), so don't commit local
  agent state there.
- Run `terraform fmt` before committing. CI fails on unformatted HCL.
- Commit subjects generally follow Conventional Commits. Use a scope when it adds context, and
  include an issue or PR number when the work is tracked by one; do not invent a reference for
  untracked work.
