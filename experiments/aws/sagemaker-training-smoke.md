# AWS SageMaker Training Smoke — Run Record

Date: `2026-09-07`

Run ID: `TBD` (assigned at actual launch)

Provider: `aws`

Git commit SHA: `TBD` (assigned at actual launch)

GitHub issue: `rmems/Dioscuri-Cloud#54`

Linear issue: `RM-77`

## Status: BLOCKED — prerequisites not yet applied

This is a readiness record, not a completed run. The training-job launch
documented in `providers/aws/training-image-runbook.md` and
`providers/aws/managed-ml-smoke-test.md` ("Training Job Path") has **not**
been executed, because its prerequisites are code-complete but not yet
live:

| Prerequisite | Status |
|---|---|
| S3 training bucket (`terraform/envs/aws-training`, #47) | Terraform written and reviewed (PR #67), **not yet applied** — no live bucket |
| SageMaker execution role + ECR repo (`terraform/modules/training_execution`, #61) | Terraform written and reviewed (PR #68), **not yet applied** — no live role/repo |
| Training image pushed to ECR | Dockerfile written and reviewed (PR #68), **not yet built/pushed** — no image to reference |
| Tiny training dataset staged in S3 | Not staged — no bucket exists yet to stage it in |

Launching a real `aws sagemaker create-training-job` today would fail
immediately (no execution role ARN, no ECR image, no bucket) — there is no
value in attempting it before #47/#61 land, and doing so risks a confusing,
uninformative failure rather than a real go/no-go signal.

## GPU Smoke-Test Readiness Checklist (docs/runbooks/gpu-smoke-test-readiness.md)

- [x] Local baseline completed — not applicable to a managed SageMaker job (no local GPU code path to exercise first; the container itself is the code path, and its `--help`/dry-run behavior is documented in `training/docker/README.md`)
- [ ] No-GPU object storage smoke completed — blocked on #47 bucket existing
- [x] Cost estimate recorded (below)
- [x] Provider / region / SKU selected (below)
- [ ] Quota / availability checked — requires a real AWS account session against the training account
- [x] Terraform plan reviewed — PRs #67/#68 CI-validated (`terraform validate` + `terraform test`); real `terraform plan` against HCP pending workspace creation
- [x] Artifact path selected: `s3://<bucket>/training/checkpoints/<run_id>/` per `docs/training/artifact-layout.md`
- [x] Experiment manifest template prepared (`docs/schemas/experiment-manifest.md`, training fields)
- [x] Teardown checklist linked (`docs/runbooks/teardown-checklist.md`) — see Teardown section below for why a SageMaker job's teardown looks different from a deletable resource
- [ ] Max runtime / cost cap defined — proposed below, needs operator sign-off before launch

## Planned run

- Provider: `aws`
- Region: `TBD` — must match the region the `dioscuri-cloud-aws-training` bucket and ECR repository are created in (not yet chosen; #47/#61 have no default region baked in, by design — see `docs/hcp/provider-variable-map.md`)
- Instance type: `ml.g4dn.xlarge` (smallest common single-GPU SageMaker training instance type; matches `terraform/modules/training_node`'s EC2 default for consistency)
- Max runtime: `1800` seconds (30 minutes) — generous upper bound for a "tiny job"; actual smoke should complete in minutes
- Max cost cap (USD): `$25` (default AWS cap per `docs/credits/inventory.md`; this smoke should cost well under $1 for a `ml.g4dn.xlarge` running a few minutes)
- Artifact path: `s3://<bucket>/training/checkpoints/<run_id>/`

## Cost

Estimated cost USD: `< 1` (a few minutes of `ml.g4dn.xlarge`, well under the $25 default cap)

Actual cost USD: `TBD` (not run)

Cost-ledger reference: `cost-ledger.md` — AWS SageMaker training smoke row (est. only, not yet applied)

## Teardown

Resources created: `none` (not run)

Teardown evidence: `N/A` — nothing to tear down yet. Note for the eventual
real run: SageMaker training jobs are not deleted like a compute
instance — they run to a terminal state (`Completed`/`Failed`/`Stopped`).
"Teardown evidence" for this run type is the job's terminal
`DescribeTrainingJob` status, not a delete confirmation.

## Notes

Filed as a readiness record rather than skipped entirely so the blocker is
explicit and trackable: once PR #67 and PR #68 are merged and applied
(HCP workspace created, bucket live, execution role + ECR repo live, image
pushed), this file should be updated in place with the real `run_id`,
commit SHA, actual launch command used, and results — not replaced with a
new file — to keep the readiness-to-completion history in one place.
