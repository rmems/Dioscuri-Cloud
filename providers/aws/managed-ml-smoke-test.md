# AWS Managed ML Smoke-Test Runbook

This runbook documents a minimal AWS managed-ML smoke test for `Dioscuri-Cloud`.

This is a smoke test only:
- shortest viable runtime
- smallest viable managed-ML resource footprint
- enough output to prove the path works
- full teardown required afterward

This document is public-repo safe:
- no AWS credentials committed
- no secrets committed
- no account IDs required in git

## Scope

Primary target:
- AWS SageMaker or an equivalent minimal managed-ML inference/training path

Do not use this runbook for:
- benchmarking sweeps
- dataset-scale experiments
- productionized model hosting
- long-lived endpoint deployments

## Required Supporting Docs

- ../../docs/runbooks/gpu-smoke-test-readiness.md
- ../../docs/runbooks/teardown-checklist.md
- ../../docs/schemas/experiment-manifest.md
- ../../cost-ledger.md (link the concrete row, PR, or issue comment when recording the estimate)

## Prerequisites

1. Readiness complete
- Finish the generic GPU smoke-test readiness checklist.

2. AWS account and region chosen
- Select the exact AWS region before launch.
- Confirm the region supports the planned SageMaker path and chosen instance type.

3. Authentication path prepared
- Use temporary credentials, SSO, or HCP Terraform workspace variables.
- Do not commit AWS keys.

Examples:
- `AWS_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN` (if temporary credentials are used)

4. Artifact destination chosen
- Preselect a bucket/prefix for smoke-test artifacts.
- Use append-only layout:
  - `dioscuri-cloud/smoke-tests/aws/<YYYY-MM-DD>/<run_id>/`

5. Cost and teardown plan recorded
- Add or prepare the `cost-ledger.md` row before provisioning.
- Define max runtime and max cost cap before launch.

## Recommended Minimal AWS Smoke-Test Shape

Choose the smallest managed-ML path that proves the AWS path is alive.

Good smoke-test examples:
- create the minimal SageMaker-compatible job or endpoint config
- run one known-good model or tiny sample input
- emit one result artifact bundle
- tear down all compute/endpoints immediately

Success criteria:
- managed-ML job or endpoint comes up successfully
- one inference or tiny training path completes
- expected artifacts/metadata are captured
- teardown evidence is collected

## Pre-Launch Metadata

Before starting, pre-fill the manifest fields you already know:
- `run_id`
- `git_commit_sha`
- `repo`
- `model_slug`
- `saaq_version`
- `telemetry_source`
- `provider` = `aws`
- `region`
- `instance_type`
- `gpu_type`
- `artifact_uris` target prefix

## Execution

1. Record `start_time_utc`.
2. Launch the smallest viable SageMaker or managed-ML path.
3. Execute one minimal smoke action only:
   - one known-good inference request, or
   - one tiny managed training invocation
4. Capture outputs:
   - job/endpoint identifiers
   - command/request payload summary
   - result artifact(s)
   - console or CLI confirmation
5. Record `end_time_utc`, estimated cost, and actual cost if already visible.

## Captured Output Expectations

Minimum captured outputs:
- service/job/endpoint identifier
- region and instance type
- smoke-test result or success marker
- experiment manifest JSON
- one console screenshot, CLI output snippet, or service log link

## Cost Notes

AWS managed endpoints and jobs can continue billing if not deleted promptly.

Rules:
- use the smallest viable instance type
- avoid leaving endpoints deployed after validation
- record provider = `aws` in `cost-ledger.md`

## Teardown

Use `docs/runbooks/teardown-checklist.md` as the required teardown evidence source.

AWS-specific minimum teardown:
- delete SageMaker endpoints
- delete endpoint configs if no longer needed
- stop/delete training jobs if applicable
- confirm no retained volumes, notebooks, or related networking resources remain unintentionally
- confirm only intended S3 artifacts remain

Acceptable evidence:
- SageMaker console showing no active endpoint/job
- AWS CLI output confirming deletion
- Terraform destroy / HCP Terraform run link if Terraform was used

## Training Job Path (GitHub #54)

The sections above cover managed ML generically (inference or training).
This section is the **explicit training-job path** — AWS primary, Azure ML
only as a documented fallback if AWS is blocked (do not improvise
SageMaker-shaped resources on Azure; that needs its own follow-on issue).

Prerequisites (all from this epic, not re-implemented here):
- S3 bucket from `terraform/envs/aws-training` (GitHub #47) — dataset input
  and checkpoint/log output, laid out per `docs/training/artifact-layout.md`.
- SageMaker execution role + ECR repository from
  `terraform/modules/training_execution` (GitHub #61), with the training
  image already built and pushed per `providers/aws/training-image-runbook.md`.
- A tiny dataset already staged at `s3://<bucket>/training/datasets/<slug>/`.

Launch (CLI; HCP-managed apply/state is for the Terraform prerequisites
above, not for the job itself — SageMaker jobs are launched directly, not
through `terraform apply`):

```bash
aws sagemaker create-training-job \
  --training-job-name "<run_id>" \
  --algorithm-specification TrainingImage="<ecr_repository_url>:<tag>",TrainingInputMode=File \
  --role-arn "<execution_role_arn>" \
  --input-data-config '[{
    "ChannelName": "training",
    "DataSource": {
      "S3DataSource": {
        "S3DataType": "S3Prefix",
        "S3Uri": "s3://<bucket>/training/datasets/<slug>/",
        "S3DataDistributionType": "FullyReplicated"
      }
    }
  }]' \
  --output-data-config S3OutputPath="s3://<bucket>/training/checkpoints/<run_id>/" \
  --resource-config InstanceType=ml.g4dn.xlarge,InstanceCount=1,VolumeSizeInGB=50 \
  --stopping-condition MaxRuntimeInSeconds=1800
```

Monitor and confirm teardown:

```bash
aws sagemaker describe-training-job --training-job-name "<run_id>"
# SageMaker training jobs are not "deleted" — they run to completion,
# failure, or are stopped. Teardown evidence for a training job is its
# terminal DescribeTrainingJob status (Completed/Failed/Stopped), not a
# delete call.
aws sagemaker stop-training-job --training-job-name "<run_id>"   # if it must be stopped early
```

Write the run manifest (`docs/schemas/experiment-manifest.md` training
fields) to `s3://<bucket>/training/manifests/<run_id>.json` with `job_type
= training`, `trainer`, `steps_configured`/`steps_completed`,
`dataset_uri`, and `checkpoint_uri` populated from the actual job.

### Azure ML fallback (only if AWS is blocked)

Do not reuse the SageMaker role/ECR/S3 resources above as if they were
Azure resources. A follow-on issue must define, separately: an Azure Blob
container matching `docs/training/artifact-layout.md`, an Azure Container
Registry image, a managed identity/Azure ML compute job, and the
Azure-equivalent dependencies replacing #47/#61's AWS artifacts. Until that
follow-on issue exists, treat Azure as credit inventory only for this path
(see `docs/credits/inventory.md`).

## Post-Run Record

Before closing the smoke test:
- update `cost-ledger.md`
- attach or link the experiment manifest
- attach teardown evidence
- note anything intentionally retained and why
