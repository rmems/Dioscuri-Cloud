# Teardown Evidence Checklist

Every cloud run/experiment in this repo must include teardown evidence.

The goal is to prove that billable resources were destroyed, or that anything intentionally retained is explicitly documented with a cost note.

This checklist is provider-neutral and applies to AWS/Azure/GCP/DigitalOcean/IBM/Vultr and any future providers.

## What To Destroy vs Preserve

Destroy (default):
- Compute instances (CPU/GPU)
- Kubernetes clusters
- Managed databases
- Load balancers
- Public IPs / elastic IPs
- NAT gateways / routers
- Unattached disks / volumes
- Snapshots/images created for the run (unless explicitly required)
- Temporary service accounts / keys

Preserve (intentional, documented):
- Artifacts in object storage required for reproducibility
- Logs/metrics traces required for postmortems
- Minimal long-lived primitives (artifact buckets, registries) that are part of the lab baseline

If anything is preserved, document:
- why
- expected monthly cost
- owner
- teardown date or review cadence

## Provider-Neutral Checks

1. Compute
- All instances destroyed (not merely stopped—stopped VMs still incur disk/IP charges)
- GPUs released (no running GPU nodes)
- Autoscaling groups/node pools/K8s clusters scaled to zero or deleted
- Spot/preemptible instances terminated

2. Storage
- Unattached disks/volumes checked and deleted
- Snapshots/images reviewed and deleted unless required
- Object storage:
  - confirm only intended artifacts remain
  - confirm lifecycle rules if retention is long-term

3. Network
- Load balancers deleted
- Public IPs released
- Firewalls/security groups reviewed for overly-broad rules
- VPNs/tunnels torn down

4. IAM / Secrets
- Temporary credentials revoked
- Service accounts/roles created for the run removed (unless baseline)
- Access keys rotated if used

5. Terraform / HCP Terraform
- If Terraform was used:
  - `terraform destroy` executed for ephemeral stacks (or workspace deleted)
  - no pending runs stuck in HCP Terraform
  - state reflects the intended final (torn down) resources

6. Cost Tracking (Required)
- `cost-ledger.md` entry is updated:
  - estimated vs actual cost
  - teardown evidence link
  - notes if anything is retained

## Evidence Template (Paste Into PR/Issue/Report)

```text
Teardown Evidence

Run:
- Date: <YYYY-MM-DD>
- Provider: <aws|azure|gcp|do|ibm|vultr>
- Linear: <KEY or URL>
- PR: <URL>

Destroyed:
- Compute: <destroyed + identifiers>
- GPU resources: <released + identifiers>
- Disks/Volumes: <checked + deleted if unattached>
- Load balancers / Public IPs: <deleted/released>
- Snapshots/Images: <reviewed + deleted/retained>
- IAM keys/service accounts: <revoked/deleted>

Artifacts Preserved:
- Storage path(s): <bucket/prefix>
- Reason: <why needed>
- Expected ongoing cost: <$X/month or 0>
- Review/teardown date: <date>

Proof:
- Console link(s): <...>
- CLI output snippet(s): <...>
- Terraform destroy summary / HCP run link: <...>

Cost ledger:
- Row updated: <link or commit>
```

## Examples of Acceptable Evidence

- CLI output showing deletion, e.g. `terraform destroy` summary or `kubectl get nodes` showing no nodes.
- Provider console screenshot showing "0 instances" (deleted, not merely stopped) and no active load balancers.
- HCP Terraform run link showing a successful destroy or workspace deletion.
- Audit log links for resource deletion (where available).
