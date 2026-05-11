# AWS Runbook

## Purpose
MLOps/certification-aligned lab environment for SAAQ support workflows.

## Intended services
- S3
- ECR
- IAM
- CloudWatch
- Optional: SageMaker or AWS Batch for controlled smoke workflows

## Spend posture
Avoid heavy GPU spend unless explicitly approved and cost-estimated.

## Artifact bucket plan
- Use a dedicated lab S3 bucket prefix per run ID.
- Keep only sanitized logs/manifests/metrics summaries.
- Enforce lifecycle cleanup where appropriate.

## Container image plan
- Build/publish lab images to ECR with immutable tags.
- Tag by git SHA and run ID.
- Keep Docker build args free of embedded secrets.

## IAM safety notes
- Prefer least-privilege roles per workflow.
- Avoid long-lived static keys when role-based auth is possible.
- Never commit IAM credentials or session artifacts.

## Teardown checklist
- Stop compute jobs/endpoints/notebooks.
- Remove temporary storage and stale ECR images as needed.
- Verify CloudWatch/log retention scope.
- Confirm no unexpected billable resources remain.

## Cost notes
- Keep AWS usage focused on MLOps pipeline practice first.
- GPU runs are secondary and must be explicitly justified.
