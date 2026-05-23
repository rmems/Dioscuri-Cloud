# No-GPU Object Storage Smoke Test

Goal: prove this repo can generate a small artifact locally and upload it to cloud object storage without provisioning GPU resources.

This is the cheapest end-to-end signal before any GPU work:
- generate artifact
- upload artifact
- record the run
- confirm teardown/cleanup expectations

## Success Criteria

- Artifact files are created locally.
- Artifact files are uploaded to an object-storage path that includes:
  - provider
  - date
  - run ID
- A run record is created (template below) with links and hashes.
- A `cost-ledger.md` entry exists (even if estimated cost is $0.00).

Failure criteria:
- Upload overwrites a previous run.
- Storage path does not include provider/date/run ID.
- Any secret is committed to git.

## Object Storage Layout

Use an append-only layout:

`dioscuri-cloud/smoke-tests/<provider>/<YYYY-MM-DD>/<run_id>/`

Examples:
- `dioscuri-cloud/smoke-tests/gcp/2026-05-23/01J0.../`
- `dioscuri-cloud/smoke-tests/ibm/2026-05-23/01J0.../`

## Generate Artifacts

From repo root:

```bash
mkdir -p /tmp/dioscuri-cloud-smoke
bash experiments/no-gpu-object-storage-smoke/make-artifacts.sh /tmp/dioscuri-cloud-smoke
```

This generates:
- `hello-dioscuri-cloud.txt`
- `manifest.json`
- `summary.json`

## Upload (Pick One Provider)

These commands are examples. Use credentials configured via HCP Terraform workspace variables or your local shell environment; do not commit secrets.

### AWS (S3)

```bash
export PROVIDER=aws
export RUN_DATE="$(date -u +%F)"
export RUN_ID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
export S3_BUCKET="<your-bucket>"

aws s3 cp /tmp/dioscuri-cloud-smoke "s3://$S3_BUCKET/dioscuri-cloud/smoke-tests/$PROVIDER/$RUN_DATE/$RUN_ID/" --recursive
```

### GCP (GCS)

```bash
export PROVIDER=gcp
export RUN_DATE="$(date -u +%F)"
export RUN_ID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
export GCS_BUCKET="<your-bucket>"

gsutil -m cp -r /tmp/dioscuri-cloud-smoke/* "gs://$GCS_BUCKET/dioscuri-cloud/smoke-tests/$PROVIDER/$RUN_DATE/$RUN_ID/"
```

### IBM Cloud (COS)

```bash
export PROVIDER=ibm
export RUN_DATE="$(date -u +%F)"
export RUN_ID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
export COS_BUCKET="<your-bucket>"

# Example using ibmcloud COS CLI plugin (install/configure separately)
ibmcloud cos upload --bucket "$COS_BUCKET" --key "dioscuri-cloud/smoke-tests/$PROVIDER/$RUN_DATE/$RUN_ID/hello-dioscuri-cloud.txt" --file /tmp/dioscuri-cloud-smoke/hello-dioscuri-cloud.txt
ibmcloud cos upload --bucket "$COS_BUCKET" --key "dioscuri-cloud/smoke-tests/$PROVIDER/$RUN_DATE/$RUN_ID/summary.json" --file /tmp/dioscuri-cloud-smoke/summary.json
ibmcloud cos upload --bucket "$COS_BUCKET" --key "dioscuri-cloud/smoke-tests/$PROVIDER/$RUN_DATE/$RUN_ID/manifest.json" --file /tmp/dioscuri-cloud-smoke/manifest.json
```

## Run Record Template

Create a run record file (copy/paste and fill):

`experiments/no-gpu-object-storage-smoke/run-record-<YYYY-MM-DD>-<provider>-<run_id>.md`

Template:

```text
Date: <YYYY-MM-DD>
Provider: <aws|gcp|ibm|azure|do|vultr>
Run ID: <run_id>

Artifact prefix:
dioscuri-cloud/smoke-tests/<provider>/<YYYY-MM-DD>/<run_id>/

Artifacts:
- hello-dioscuri-cloud.txt
  - sha256: <...>
  - remote URL/path: <...>
- manifest.json
  - sha256: <...>
  - remote URL/path: <...>
- summary.json
  - sha256: <...>
  - remote URL/path: <...>

Cost ledger:
- cost-ledger.md row link or PR link: <...>

Teardown/cleanup:
- If any temporary credentials were created, revoke them.
- If any temporary buckets/containers were created, delete them.
- Evidence link (console/CLI/audit): <...>
```

## Cost Ledger + Teardown

- Add an entry to `cost-ledger.md` for the run.
- If this smoke test created any cloud resources (bucket, service account, keys), teardown must be documented with evidence.
