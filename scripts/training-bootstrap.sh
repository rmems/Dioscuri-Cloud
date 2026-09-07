#!/usr/bin/env bash
# One-script bootstrap preflight for the AWS training environment (Issue #62).
# Public-safe: never reads or prints secret values. Fails closed — each
# numbered check must pass before the next runs. See docs/training/bootstrap.md
# for required environment variables and where credentials live.
set -euo pipefail

log() { printf '\n== %s ==\n' "$1"; }
fail() {
  printf 'BLOCKED: %s\n' "$1" >&2
  exit 1
}

# 1. HCP: confirm Terraform Cloud auth is configured for org Dioscuri-Cloud,
#    workspace dioscuri-cloud-aws-training (terraform/envs/aws-training).
log "1/5 HCP Terraform authentication"
command -v terraform >/dev/null 2>&1 || fail "terraform CLI not found. Install Terraform first."
if [ -z "${TF_TOKEN_app_terraform_io:-}" ] && [ ! -f "${HOME}/.terraform.d/credentials.tfrc.json" ]; then
  fail "No HCP Terraform Cloud auth found. Run 'terraform login' or set TF_TOKEN_app_terraform_io. See docs/hcp/vcs-integration.md."
fi
echo "OK: TF_TOKEN_app_terraform_io or local Terraform Cloud credentials present."

# 2. AWS: confirm the training account/profile resolves a caller identity.
log "2/5 AWS caller identity"
command -v aws >/dev/null 2>&1 || fail "aws CLI not found. Install the AWS CLI first."
aws sts get-caller-identity >/dev/null 2>&1 ||
  fail "aws sts get-caller-identity failed. Check AWS_PROFILE / AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY / AWS_REGION for the training account."
echo "OK: AWS credentials resolve to a caller identity."

# 3. S3: probe the training bucket's training/ prefix (docs/training/artifact-layout.md).
log "3/5 S3 training bucket probe"
: "${TRAINING_BUCKET_NAME:?TRAINING_BUCKET_NAME is required — set it to the bucket_name from terraform/envs/aws-training (see docs/hcp/provider-variable-map.md). Never hardcode it in a script or commit it.}"
aws s3api list-objects-v2 --bucket "${TRAINING_BUCKET_NAME}" --prefix "training/" --max-items 1 >/dev/null 2>&1 ||
  fail "Could not list s3://${TRAINING_BUCKET_NAME}/training/. Confirm the bucket has been applied (dioscuri-cloud-aws-training workspace) and your IAM identity has s3:ListBucket on it."
echo "OK: s3://${TRAINING_BUCKET_NAME}/training/ is reachable."

# 4. Docker: build or pull the training image (training/docker/, Issue #61).
log "4/5 Training image"
command -v docker >/dev/null 2>&1 || fail "docker not found. Install Docker first."
if [ -n "${TRAINING_ECR_REPOSITORY_URL:-}" ]; then
  IMAGE_TAG="${TRAINING_IMAGE_TAG:-latest}"
  docker pull "${TRAINING_ECR_REPOSITORY_URL}:${IMAGE_TAG}" ||
    fail "docker pull ${TRAINING_ECR_REPOSITORY_URL}:${IMAGE_TAG} failed. Confirm ECR auth (providers/aws/training-image-runbook.md) and that this tag has been pushed."
  echo "OK: pulled ${TRAINING_ECR_REPOSITORY_URL}:${IMAGE_TAG}."
else
  docker build -t dioscuri-cloud-training:bootstrap-check "$(dirname "$0")/../training/docker" ||
    fail "docker build of training/docker failed."
  echo "OK: built dioscuri-cloud-training:bootstrap-check locally."
fi

# 5. Optional dry-run: GPU node (nvidia-smi via SSM) or SageMaker job describe.
#    Neither TRAINING_GPU_INSTANCE_ID nor TRAINING_SAGEMAKER_JOB_NAME can
#    exist yet until #53 or #54 provisions one — this step is skip-safe.
log "5/5 Optional dry-run"
if [ -n "${TRAINING_GPU_INSTANCE_ID:-}" ]; then
  aws ssm send-command \
    --instance-ids "${TRAINING_GPU_INSTANCE_ID}" \
    --document-name "AWS-RunShellScript" \
    --parameters commands="nvidia-smi" \
    >/dev/null ||
    fail "SSM nvidia-smi dry-run on ${TRAINING_GPU_INSTANCE_ID} failed to dispatch. Confirm the instance has the SSM agent and an instance profile with ssm:SendCommand."
  echo "OK: dispatched nvidia-smi dry-run via SSM to ${TRAINING_GPU_INSTANCE_ID}. Check the SSM command output for the actual GPU status."
elif [ -n "${TRAINING_SAGEMAKER_JOB_NAME:-}" ]; then
  aws sagemaker describe-training-job --training-job-name "${TRAINING_SAGEMAKER_JOB_NAME}" >/dev/null ||
    fail "aws sagemaker describe-training-job for ${TRAINING_SAGEMAKER_JOB_NAME} failed."
  echo "OK: SageMaker training job ${TRAINING_SAGEMAKER_JOB_NAME} is describable."
else
  echo "SKIPPED: no TRAINING_GPU_INSTANCE_ID or TRAINING_SAGEMAKER_JOB_NAME set — no compute dry-run requested. Expected before #53/#54 provision a node/job."
fi

log "Bootstrap preflight complete"
echo "All required checks passed. See docs/training/bootstrap.md for what each step verified."
