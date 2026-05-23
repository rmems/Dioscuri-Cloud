# GPU Smoke-Test Readiness Checklist

This checklist must be completed before any GPU smoke test runs in the cloud.

The purpose is to block ad hoc GPU spend. GPU runs are allowed only after the code path, artifact path, cost estimate, manifest shape, and teardown path are all prepared.

This checklist applies to AWS, Azure, GCP, IBM, DigitalOcean, Vultr, and future providers.

## What This Checklist Gates

A GPU run may proceed only when all required items below are complete and documented in the run issue or PR.

Required supporting docs:
- `cost-ledger.md`
- `docs/schemas/experiment-manifest.md`
- `docs/runbooks/teardown-checklist.md`
- `experiments/no-gpu-object-storage-smoke/README.md`

## Required Readiness Checks

1. Local baseline completed
- The exact code path has been exercised locally.
- The local run produced the expected artifact shape or logs.
- Any known local instability is documented before cloud spend begins.

2. No-GPU object storage smoke test completed
- The no-GPU smoke path has already proven:
  - artifact generation works
  - upload path works
  - run records can be written
- If the GPU run depends on a different bucket/prefix/provider, document the difference explicitly.

3. Cost estimate recorded
- A cost estimate is written before provisioning.
- The estimate is recorded in the linked issue/PR and reflected in `cost-ledger.md`.

4. Provider / region / GPU SKU selected
- Provider chosen, e.g. `aws`, `azure`, `gcp`, `ibm`, `do`, `vultr`.
- Region chosen.
- Exact machine/GPU SKU chosen.
- Reason for that SKU is documented (availability, cost, compatibility, or quota).

5. Quota / availability checked
- The account has quota for the selected GPU SKU.
- The selected region currently offers the SKU.
- Any fallback region/SKU is documented before launch.

6. Terraform plan reviewed
- The Terraform plan or equivalent infrastructure diff has been reviewed before apply.
- The plan does not include unrelated resources.
- No secrets or credentials are committed.

7. Artifact path selected
- The storage path is selected before the run begins.
- It is unique and append-only.
- Preferred pattern:
  - `dioscuri-cloud/smoke-tests/<provider>/<YYYY-MM-DD>/<run_id>/`

8. Experiment manifest template prepared
- A manifest based on `docs/schemas/experiment-manifest.md` is prepared before launch.
- Required fields are known in advance where possible:
  - `run_id`
  - `git_commit_sha`
  - `repo`
  - `model_slug`
  - `saaq_version`
  - `telemetry_source`
  - `provider`
  - `region`
  - `instance_type`
  - `gpu_type`

9. Teardown checklist linked
- The run issue/PR links `docs/runbooks/teardown-checklist.md`.
- The operator knows what will be destroyed versus intentionally preserved.

10. Max runtime / cost cap defined
- A hard stop runtime is defined before launch.
- A maximum budget cap is defined before launch.
- If either cap is exceeded, the run must be stopped and documented.

## Minimal GPU Smoke Test vs Real Experiment

### Minimal GPU smoke test

This is allowed only to prove that cloud GPU infrastructure basically works.

Characteristics:
- shortest viable runtime
- smallest viable GPU SKU
- smallest viable dataset/prompt/sample
- success criteria limited to setup/boot/inference/artifact write/basic teardown
- no tuning, no benchmarking sweep, no broad parameter exploration

Examples:
- boot one instance, run a single checkpoint load, emit one artifact bundle, tear down
- run a one-shot inference sanity check with a known-good prompt and store outputs

### Real experiment

This goes beyond infrastructure smoke.

Characteristics:
- repeated runs or parameter sweeps
- comparative benchmarking
- larger datasets or replay corpora
- profiling, telemetry analysis, or cost/performance study
- retained infrastructure beyond the baseline smoke window

If the planned work matches this description, do not treat it as a smoke test. Open a dedicated experiment issue with explicit cost, scope, and teardown expectations.

## Approval Template

Use this template when opening or approving a GPU run issue:

```text
GPU Smoke-Test Readiness

- GitHub issue: <owner/repo#number>
- Linear issue: <KEY or URL>
- Commit SHA: <sha>
- Date: <YYYY-MM-DD>

Readiness:
- [ ] Local baseline completed
- [ ] No-GPU object storage smoke completed
- [ ] Cost estimate recorded in cost-ledger.md
- [ ] Provider selected
- [ ] Region selected
- [ ] GPU SKU selected
- [ ] Quota/availability checked
- [ ] Terraform plan reviewed
- [ ] Artifact path selected
- [ ] Experiment manifest template prepared
- [ ] Teardown checklist linked
- [ ] Max runtime defined
- [ ] Max cost cap defined

Planned run:
- Provider: <...>
- Region: <...>
- Instance type: <...>
- GPU type: <...>
- Max runtime: <...>
- Max cost cap (USD): <...>
- Artifact path: <...>

Approval note:
This run qualifies as a minimal GPU smoke test, not a real experiment.
```

## Blocking Rule

If any required item above is missing, the GPU run is not ready and should not start.
