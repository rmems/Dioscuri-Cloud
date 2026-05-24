# Vultr Credit Closeout

Use this closeout before the Vultr credit expiration on `2026-05-28`, and after any no-GPU, GPU, or inference run.

Closeout goals:
- prove no accidental billable resources remain
- reconcile `cost-ledger.md` Vultr rows
- document API key revoke/rotation status
- record whether Vultr remains useful for Dioscuri-Cloud

## Resource Audit

Run read-only CLI/API checks where possible and redact private account details before sharing output.

Minimum categories to check:
- cloud compute instances
- GPU instances
- inference endpoints or hosted model resources
- block storage volumes
- object storage buckets
- snapshots and custom images
- reserved IPs
- load balancers
- firewall resources and network attachments

Candidate commands:

```bash
vultr-cli instance list
vultr-cli block-storage list
vultr-cli object-storage list
vultr-cli snapshot list
vultr-cli reserved-ip list
vultr-cli load-balancer list
vultr-cli firewall group list
```

If a command is unsupported by the installed CLI version, record the replacement API or console path in the closeout record.

## Teardown Rules

Default teardown result:
- no running compute
- no GPU instances
- no inference endpoints
- no unattached block storage
- no reserved IPs
- no load balancers
- no unneeded snapshots or custom images
- no temporary API tokens retained unless documented

If anything is intentionally retained, record:
- owner
- reason
- expected monthly cost
- next review or teardown date
- evidence that the retention is intentional

## Cost Reconciliation

For every Vultr row in `cost-ledger.md`, update:
- actual cost when visible
- `TBD` plus the exact follow-up date if cost is not visible yet
- teardown evidence link or public-safe summary
- notes for retained resources, if any

Do not fabricate cost data. If the provider has not posted usage yet, mark the actual cost as `TBD` and document where to check next.

## API Key Cleanup

After the final run or no-go decision:
- revoke temporary API keys that are no longer needed
- rotate any key used from a shared operator environment if exposure is suspected
- remove unused HCP Terraform workspace variables
- record the decision as `revoked`, `rotated`, or `retained with reason`

Do not commit key names, token values, token prefixes, or screenshots that identify private account details.

## Final Provider Recommendation

Record exactly one recommendation in the closeout template:
- `keep opportunistic`: Vultr remains useful for short GPU/inference windows
- `fallback-only`: keep docs, but prefer other providers for planned runs
- `remove from active short-term execution path`: do not plan near-term work on Vultr

## Closeout Template

Use `experiments/vultr/closeout-template.md` for the final public-safe report.

Related docs:
- Bootstrap: `providers/vultr/bootstrap.md`
- Credit inventory: `docs/credits/inventory.md`
- Cost ledger: `cost-ledger.md`
- Teardown checklist: `docs/runbooks/teardown-checklist.md`
- GPU go/no-go: `experiments/vultr/gpu-go-no-go/README.md`
- GPU smoke test: `experiments/vultr/gpu-smoke-test/README.md`
