# AWS SageMaker Training Smoke — Run Record

Date: `2026-09-07`

Run ID: `TBD` (assigned at actual launch)

Provider: `aws`

Git commit SHA: `TBD` (assigned at actual launch)

GitHub issue: `rmems/Dioscuri-Cloud#54`

Linear issue: `RM-77`

## Status: BLOCKED — sibling PRs on `main`; nothing applied; no spend

This is a readiness record, not a completed run. AWS training is **not**
ready. The launch path in `providers/aws/managed-ml-smoke-test.md`
("Training Job Path") has **not** been executed. There has been **no**
`terraform apply`, **no** `CreateTrainingJob`, and **no** billable AWS
spend for this smoke.

The bucket env, execution-role/ECR/image, and bootstrap preflight are
now on `main` via merged PRs #67/#68/#71. **Code on `main` is not
applied infrastructure.** Do not invent live ARNs/URIs:

| Prerequisite | Status |
|---|---|
| S3 training bucket (`terraform/envs/aws-training`, #47) | Merged [PR #67](https://github.com/rmems/Dioscuri-Cloud/pull/67) — **on `main`, not applied** — no live bucket |
| SageMaker execution role + ECR repo (`terraform/modules/training_execution`, #61) | Merged [PR #68](https://github.com/rmems/Dioscuri-Cloud/pull/68) — **on `main`, not instantiated in `terraform/envs/aws-training`, not applied** — no live role/repo |
| Training image + `providers/aws/training-image-runbook.md` | Same merged [PR #68](https://github.com/rmems/Dioscuri-Cloud/pull/68) — runbook and `training/docker/` are on `main`; **image not built/pushed** |
| Fail-closed bootstrap preflight (`scripts/training-bootstrap.sh`, #62) | Merged [PR #71](https://github.com/rmems/Dioscuri-Cloud/pull/71) — script is on `main`; optional once live resources exist; would fail closed today |
| Tiny training dataset staged in S3 | Not staged — no live bucket exists yet to stage it in |

Launching a real `aws sagemaker create-training-job` today would fail
immediately (no execution role ARN, no ECR image, no bucket). Do not
attempt it until #67/#68 are applied and a real image exists; #71 is
an optional preflight once those live resources exist. Placeholder
ARNs/URIs in the runbook are not real values. At launch, record the
echoed `SAGEMAKER_JOB_NAME` in this file and in the manifest `notes`
so monitor/teardown do not depend on re-deriving the name.

## GPU Smoke-Test Readiness Checklist (docs/runbooks/gpu-smoke-test-readiness.md)

- [ ] Local baseline completed — **not yet done.** `training/docker/README.md` (now on `main` via [PR #68](https://github.com/rmems/Dioscuri-Cloud/pull/68)) only documents `--help` / `python3`+torch dry-run *behavior*; the readiness checklist requires the exact code path to actually be exercised locally with real output, which hasn't happened. Do not treat the paid SageMaker launch as the first real exercise of this container.
- [ ] No-GPU object storage smoke completed — blocked on #47 bucket existing (code on `main` via #67; **not applied**)
- [x] Cost estimate recorded (below)
- [ ] Provider / region / SKU selected — provider (`aws`) and SKU (`ml.g4dn.xlarge`) are chosen, but **region is still `TBD`** (see Planned run below); leave this unchecked until a concrete region is recorded, since the region gates whether the bucket/ECR image/requested capacity actually line up
- [ ] Quota / availability checked — requires a real AWS account session against the training account
- [ ] Terraform plan reviewed — #67/#68 code on `main` may pass `terraform validate`/`terraform test` in CI; that is not a reviewed `terraform plan` against real HCP state. Leave unchecked until a real plan exists. **No apply.**
- [ ] Artifact path selected — the *scheme* is fixed (`s3://<bucket>/training/checkpoints/<run_id>/` per `docs/training/artifact-layout.md`), but both `<bucket>` and `<run_id>` are still placeholders; leave unchecked until a concrete bucket and a concrete, unique `run_id` are recorded, so a later launch can't accidentally reuse a prefix and mix `step_<n>` data or overwrite `latest.json`
- [x] Experiment manifest template prepared — run-specific draft below (not just a link to the generic schema), with known fields filled in. String fields still pending launch stay `"TBD"`; integer-typed fields use a numeric placeholder or `null` (never the string `"TBD"`)
- [x] Teardown checklist linked (`docs/runbooks/teardown-checklist.md`) — see Teardown section below for why a SageMaker job's teardown looks different from a deletable resource
- [ ] Max runtime / cost cap defined — proposed below, needs operator sign-off before launch

**Review by 2026-10-07** (or sooner, whenever #67/#68 are applied — #71 is an optional preflight, not a merge-order gate) — re-check this record and its blockers rather than letting it go stale.

## Planned run

- Provider: `aws`
- Region: `TBD` — must match the region the `dioscuri-cloud-aws-training` bucket and ECR repository are created in once #67/#68 are applied (not yet chosen; `docs/hcp/provider-variable-map.md` has no default AWS region baked in, by design). Do not launch against a guessed region.
- Instance type: `ml.g4dn.xlarge` (smallest common single-GPU SageMaker training instance type; the same SKU the #68 `training_node` module on `main` uses as its EC2 default)
- Max runtime: `1800` seconds (30 minutes) — generous upper bound for a "tiny job"; actual smoke should complete in minutes
- Max cost cap (USD): `$25` (default AWS cap per `docs/credits/inventory.md`; this smoke should cost well under $1 for a `ml.g4dn.xlarge` running a few minutes)
- Artifact path: `s3://<bucket>/training/checkpoints/<run_id>/`

## Draft run manifest

Per `docs/schemas/experiment-manifest.md` training fields — known values
filled in now. Pending string fields stay `"TBD"` until launch;
`steps_configured` is a real integer (tiny-job budget matching
`examples/training-run-manifest.synthetic.json`), not a string
placeholder. `steps_completed` stays `null` until the job runs; the
emitted post-run manifest must replace that with an integer. This is
the actual manifest shape this run will emit to
`s3://<bucket>/training/manifests/<run_id>.json`, not just a link to the
schema doc:

```json
{
  "run_id": "TBD",
  "job_type": "training",
  "git_commit_sha": "TBD",
  "repo": "rmems/Dioscuri-Cloud",
  "github_issue": "rmems/Dioscuri-Cloud#54",
  "base_model": "TBD",
  "model_slug": "TBD",
  "trainer": "TBD",
  "steps_configured": 10,
  "steps_completed": null,
  "telemetry_source": "synthetic",
  "provider": "aws",
  "region": "TBD",
  "instance_type": "ml.g4dn.xlarge",
  "gpu_type": "NVIDIA T4",
  "dataset_uri": "TBD",
  "checkpoint_uri": "TBD",
  "start_time_utc": null,
  "end_time_utc": null,
  "estimated_cost_usd": 1.0,
  "actual_cost_usd": null,
  "artifact_uris": ["TBD"],
  "teardown_confirmed": false,
  "notes": "Readiness-record draft; not yet launched. See experiments/aws/sagemaker-training-smoke.md."
}
```

## Cost

Estimated cost USD: `< 1` (a few minutes of `ml.g4dn.xlarge`, well under the $25 default cap)

Actual cost USD: `TBD` (not run)

Cost-ledger reference: `cost-ledger.md` — AWS SageMaker training smoke row (estimate only; no apply and no spend)

## Teardown

Resources created: `none` (not run)

Teardown evidence: `N/A` — nothing to tear down yet. Note for the eventual
real run: SageMaker training jobs are not deleted like a compute
instance — they run to a terminal state (`Completed`/`Failed`/`Stopped`).
"Teardown evidence" for this run type is the job's terminal
`DescribeTrainingJob` status, not a delete confirmation.

## Notes

Filed as a readiness record rather than skipped entirely so the blocker is
explicit and trackable. Sibling PRs [#67](https://github.com/rmems/Dioscuri-Cloud/pull/67),
[#68](https://github.com/rmems/Dioscuri-Cloud/pull/68), and
[#71](https://github.com/rmems/Dioscuri-Cloud/pull/71) are now on `main`.
The remaining gate is apply + image push, not merge: HCP workspace
created, bucket live, execution role + ECR repo live, image pushed —
and, if used, the #71 bootstrap preflight passing against those live
resources. When that happens, update this file in place with the real
`run_id`, the echoed `SAGEMAKER_JOB_NAME`, commit SHA, actual launch
command used, and results — not replaced with a new file — to keep the
readiness-to-completion history in one place. No apply or spend is
implied by this record.
