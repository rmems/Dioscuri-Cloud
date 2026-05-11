# Azure Runbook

## Purpose
Azure ML and certification-aligned lab track for SAAQ MLOps practice.

## Intended services
- Azure ML workspace
- Blob Storage
- Key Vault
- Optional compute for small smoke tests

## Credit uncertainty
Current expectation: $100 confirmed; possible $200 pending support confirmation.

## Secret handling (Key Vault)
- Store operational secrets in Azure Key Vault.
- Reference secrets at runtime; do not hardcode in repo files.
- Do not export secrets into committed artifacts.

## Teardown checklist
- Stop/delete compute instances or clusters.
- Remove temporary Blob artifacts outside retained run evidence.
- Confirm Key Vault object lifecycle is intentional.
- Validate no unexpected billable resources remain.

## Cost notes
- Treat Azure as structured learning/certification practice.
- Keep GPU/compute usage small and pre-estimated.
