# Vultr Bootstrap Runbook

Vultr account credit is tracked in `docs/credits/inventory.md` as `$250` expiring on `2026-05-28`.

Default guardrails:
- cap each Vultr experiment at `$25` unless explicitly approved
- prefer API-only checks before creating resources
- tear down same day unless retention is documented with owner, cost, and review date
- keep API keys, provider credentials, local state, private billing output, and generated artifacts out of git

Official docs:
- Vultr Terraform provider: <https://docs.vultr.com/reference/terraform>
- Vultr CLI reference: <https://docs.vultr.com/reference/vultr-cli>

## Safe Execution Order

1. Verify account/API access without exposing `VULTR_API_KEY`.
2. Run the no-GPU preflight in `experiments/vultr/no-gpu-preflight/`.
3. Check GPU/inference availability in `experiments/vultr/gpu-go-no-go/`.
4. Run a minimal GPU/inference smoke test only after an explicit go decision.
5. Complete teardown and ledger closeout using `providers/vultr/credit-closeout.md`.

## API Token Handling

Create a short-lived Vultr API token from the Vultr account console and scope it to the minimum needed for the run.

Allowed secret paths:
- local shell environment variable: `VULTR_API_KEY`
- HCP Terraform workspace variable: `VULTR_API_KEY`, marked sensitive

Do not commit:
- API tokens or token fragments
- shell history containing token values
- `.tfvars` files with credentials
- `.terraform/` directories
- Terraform state files
- private account, billing, or quota screenshots

Local shell pattern:

```bash
export VULTR_API_KEY='<set locally; do not paste into issues or PRs>'
```

HCP Terraform pattern:
- workspace: `dioscuri-cloud-vultr-dev`
- sensitive variable: `VULTR_API_KEY`
- non-sensitive variables: `TF_VAR_owner`, `TF_VAR_region`, `TF_VAR_resource_name_prefix`, `TF_VAR_teardown_by`

## Terraform Setup

The Vultr scaffold is in `infra/terraform/environments/vultr-dev/`.

The root module uses the official provider source `vultr/vultr`. Provider authentication is read from `VULTR_API_KEY`; the configuration must not hardcode credentials.

Validation-only commands:

```bash
terraform -chdir=infra/terraform/environments/vultr-dev fmt -recursive
terraform -chdir=infra/terraform/environments/vultr-dev init -backend=false
terraform -chdir=infra/terraform/environments/vultr-dev validate
```

Do not run `terraform apply` until the issue/PR records an approved resource plan, cost cap, runtime cap, and teardown path.

## CLI Preflight Commands

Run these only when `VULTR_API_KEY` is available locally or through the approved execution environment. Redact account-specific output before committing any run record.

```bash
vultr-cli account info
vultr-cli regions list
vultr-cli plans list
vultr-cli firewall group list
vultr-cli object-storage list
vultr-cli instance list
vultr-cli block-storage list
vultr-cli reserved-ip list
```

GPU/inference discovery candidates:

```bash
vultr-cli plans list --type vcg
vultr-cli plans list --type vhf
```

If the CLI command shape differs by installed version, record the installed CLI version and the corrected command in the run record.

If account-scoped calls return HTTP `401`, stop before any paid action. Rotate or correct the token, re-export `VULTR_API_KEY`, and rerun the no-GPU preflight before approving GPU or inference work.

## Resource Attribution

Use these labels/tags or equivalent names anywhere Vultr resources support them:

```text
owner=rmems
repo=dioscuri-cloud
provider=vultr
teardown_by=2026-05-28
```

Recommended name prefix:

```text
dioscuri-vultr
```

## Preflight Checklist

Before any paid resource is created, record:
- account/API access status
- selected target region or blocker
- relevant plan/SKU visibility or blocker
- quota/stock/access status
- expected resource names and tags
- `cost-ledger.md` row plan
- teardown evidence path
- approval status for any nonzero spend

## Related Docs

- Credit inventory: `docs/credits/inventory.md`
- Cost ledger: `cost-ledger.md`
- Terraform scaffold: `infra/terraform/environments/vultr-dev/README.md`
- No-GPU preflight: `experiments/vultr/no-gpu-preflight/README.md`
- GPU/inference go/no-go: `experiments/vultr/gpu-go-no-go/README.md`
- GPU smoke-test readiness: `docs/runbooks/gpu-smoke-test-readiness.md`
- Experiment manifest schema: `docs/schemas/experiment-manifest.md`
- Teardown checklist: `docs/runbooks/teardown-checklist.md`
- Closeout checklist: `providers/vultr/credit-closeout.md`
