# GCP / Vertex AI Runbook

## Purpose
Managed ML and Vertex AI practice for reproducible SAAQ cloud workflows.

## Prerequisites
- Ensure `gcloud` CLI is installed and authenticated
- Verify correct GCP project is selected
- Confirm billing is enabled for the project

## Quick verification checklist
```bash
# Check gcloud installation
gcloud version

# Verify authentication
gcloud auth list

# Confirm project selection
gcloud config get-value project

# List available GPU quotas (if needed)
gcloud compute regions list
```

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