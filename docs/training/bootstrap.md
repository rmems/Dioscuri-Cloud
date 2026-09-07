# Training environment bootstrap (Issue #62)

One script, `scripts/training-bootstrap.sh`, verifies the AWS training
prerequisites are in place before any job runs — it never provisions
anything and never touches billable resources beyond read-only API calls
(`sts:GetCallerIdentity`, `s3:ListBucket`, optional `sagemaker:DescribeTrainingJob`
or `ssm:SendCommand` for a dry-run). It fails closed: each numbered check
must pass before the next one runs.

## What it checks, in order

1. **HCP Terraform authentication** — `terraform` CLI is installed and either
   `TF_TOKEN_app_terraform_io` is set or `~/.terraform.d/credentials.tfrc.json`
   exists (from `terraform login`). Org `Dioscuri-Cloud`, workspace
   `dioscuri-cloud-aws-training` (`terraform/envs/aws-training`).
2. **AWS caller identity** — `aws sts get-caller-identity` succeeds for
   whatever AWS credentials are active (profile, env vars, or instance
   role) for the training account.
3. **S3 training bucket probe** — lists the `training/` prefix of the
   bucket named by `TRAINING_BUCKET_NAME` (docs/training/artifact-layout.md).
4. **Training image** — pulls `TRAINING_ECR_REPOSITORY_URL:TRAINING_IMAGE_TAG`
   if set, otherwise builds `training/docker/` locally as
   `dioscuri-cloud-training:bootstrap-check`.
5. **Optional dry-run** — if `TRAINING_GPU_INSTANCE_ID` is set, dispatches
   `nvidia-smi` to it via SSM; if `TRAINING_SAGEMAKER_JOB_NAME` is set instead,
   describes that job. If neither is set, this step is skipped — expected
   before #53/#54 provision an actual node or job.

## Usage

```bash
export TRAINING_BUCKET_NAME=<bucket_name from your HCP workspace variables>
# Optional, once #61's image is pushed to ECR:
export TRAINING_ECR_REPOSITORY_URL=<ecr_repository_url output>
export TRAINING_IMAGE_TAG=<tag>
# Optional, once #53 or #54 has provisioned compute:
export TRAINING_GPU_INSTANCE_ID=<i-...>
# or
export TRAINING_SAGEMAKER_JOB_NAME=<job-name>

./scripts/training-bootstrap.sh
```

## Required environment variables and where they live

| Variable | Required | Source |
|---|---|---|
| AWS credentials (`AWS_PROFILE` or `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`/`AWS_REGION`) | Yes | Local AWS CLI profile or HCP workspace environment variables (`docs/hcp/provider-variable-map.md`). Never committed. |
| `TF_TOKEN_app_terraform_io` (or `terraform login`) | Yes | Local HCP Terraform CLI credentials. Never committed. |
| `TRAINING_BUCKET_NAME` | Yes | The `bucket_name` value set in the `dioscuri-cloud-aws-training` HCP workspace. Globally unique; never hardcoded in this repo. |
| `TRAINING_ECR_REPOSITORY_URL`, `TRAINING_IMAGE_TAG` | No | `ecr_repository_url` output of `terraform/modules/training_execution` once #61's image is pushed (`providers/aws/training-image-runbook.md`). |
| `TRAINING_GPU_INSTANCE_ID` | No | An EC2 instance ID once #53 provisions one via `terraform/modules/training_node`. |
| `TRAINING_SAGEMAKER_JOB_NAME` | No | A SageMaker training job name once #54 launches one. |

No API keys, tokens, or account identifiers are ever written to this repo —
this script only reads environment variables the operator already has set
locally or via HCP.

## Non-goals

- No MCP/memory sync for agent swarms.
- No MiMo/Kilo/Grok IDE integration.
- No full training job — that's #59, which this bootstrap is a precondition
  for, not a substitute.
