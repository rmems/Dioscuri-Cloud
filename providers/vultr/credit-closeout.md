# Vultr Credit Closeout

Use this closeout record for the completed Vultr credit window. Vultr is not in the active near-term execution path.

Closeout goals:
- prove no accidental billable resources remain
- reconcile `cost-ledger.md` Vultr rows
- document API key revoke/rotation status
- record whether Vultr remains useful for Dioscuri-Cloud
- make clear that no Vultr API keys should be uploaded/configured for current work

## Resource Audit

Run read-only CLI/API checks where possible and redact private account details before sharing output.

Current status after the 2026-05-28 closeout: Vultr is inactive for near-term execution, and this repo update must not upload/configure Vultr API material. If no already-approved authenticated context is available, record the audit as `not performed` rather than reintroducing credentials.

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

Current PR status: no Vultr API key or Vultr HCP variable is uploaded/configured by this PR. Any provider-side cleanup for pre-existing keys must happen outside the repo and should be recorded only as a public-safe status note.

## Final Provider Recommendation

Record exactly one recommendation in the closeout template:
- `keep opportunistic`: Vultr remains useful for short GPU/inference windows
- `fallback-only`: keep docs, but prefer other providers for planned runs
- `remove from active short-term execution path`: do not plan near-term work on Vultr

Current recommendation after the 2026-05-28 credit closeout: `remove from active short-term execution path`.

## Closeout Template

Use `experiments/vultr/closeout-template.md` for the final public-safe report.

The 2026-05-27 serverless inference sprint closeout is recorded in `experiments/vultr/2026-05-27-serverless-inference-credit-sprint.md`. That report records `$237.31` consumed, `$12.69` expired, `$0.00` owed, and `1,604,112+` tokens without committing private billing identifiers or secrets. Do not upload, configure, or commit Vultr API material for the current issue bundle.

Related docs:
- Bootstrap: `providers/vultr/bootstrap.md`
- Credit inventory: `docs/credits/inventory.md`
- Cost ledger: `cost-ledger.md`
- Teardown checklist: `docs/runbooks/teardown-checklist.md`
- GPU go/no-go: `experiments/vultr/gpu-go-no-go/README.md`
- GPU smoke test: `experiments/vultr/gpu-smoke-test/README.md`
- Serverless inference sprint: `experiments/vultr/2026-05-27-serverless-inference-credit-sprint.md`
