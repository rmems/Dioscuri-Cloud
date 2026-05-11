# DigitalOcean Runbook

## Purpose
First practical GPU smoke-test provider for SAAQ cloud validation.

## Target
SAAQ cloud GPU smoke test.

## Preflight checklist
- Confirm experiment record folder exists under `experiments/`.
- Confirm model slug and source are documented.
- Confirm cost estimate is written in advance.
- Confirm teardown plan is documented.
- Confirm no secrets will be written to repo artifacts.

## GPU availability check
- Check current GPU SKU/region availability in DigitalOcean console/API.
- Record available options and fallback in experiment notes.
- If no capacity exists, stop and log failure mode.

## Instance setup outline
1. Provision minimal viable GPU instance for smoke test.
2. Install/verify NVIDIA driver + CUDA runtime compatibility.
3. Pull or build required runtime container/image.
4. Stage run configuration (without secrets in committed files).

## Artifact collection
- `run_manifest.json`
- logs and metrics snapshots (sanitized)
- result summary markdown
- cost-ledger entry + teardown confirmation

## Teardown checklist
- Stop run and persist approved artifacts.
- Delete GPU instance and attached storage.
- Remove temporary objects if any.
- Confirm no billable resources remain.
- Update `cost-ledger.md` with teardown status.

## Cost notes
- Treat DigitalOcean as first GPU target, but keep runs short.
- Use smoke-test scope only (no full training plans).

## Failure modes
- No GPU capacity
- CUDA/driver mismatch
- Model does not fit VRAM
- Artifact upload failure
