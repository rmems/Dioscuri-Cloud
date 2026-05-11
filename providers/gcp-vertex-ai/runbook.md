# GCP / Vertex AI Runbook

## Purpose
Managed ML and Vertex AI practice for reproducible SAAQ cloud workflows.

## Local environment note
Local workstation is already configured to `gcloud` (re-validate account/project before each run).

## Intended services
- Cloud Storage
- Vertex AI Workbench and/or Jobs
- IAM
- Artifact Registry (if container workflow is needed)

## Spend posture
Avoid expensive GPU usage until runbook details and a written cost estimate are ready.

## Teardown checklist
- Stop/delete Vertex resources created for the run.
- Remove temporary Cloud Storage artifacts not required for records.
- Remove temporary Artifact Registry images where appropriate.
- Confirm no unexpected billable resources remain.

## Cost notes
- Prioritize managed-service workflow learning over large compute jobs.
