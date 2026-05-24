# Vultr GPU/Inference Smoke Test

Goal: run the smallest useful Vultr GPU or inference smoke test only after `experiments/vultr/gpu-go-no-go/` records a go decision.

This is not a benchmark or real SAAQ experiment. It is a short-lived infrastructure smoke test with immediate teardown.

## Hard Gates

- #38 has a documented `go` decision.
- `docs/runbooks/gpu-smoke-test-readiness.md` is completed or linked.
- `cost-ledger.md` has a planned row before or during the run.
- Runtime cap is under 1 hour unless explicitly approved.
- Cost cap is `$25` unless explicitly approved.
- Teardown path is ready before provisioning.

## Candidate Workloads

GPU VM checks:

```bash
nvidia-smi
```

Tiny CUDA/PyTorch check if the runtime is already installed:

```bash
python - <<'PY'
import torch
print("torch", torch.__version__)
print("cuda_available", torch.cuda.is_available())
print("device_count", torch.cuda.device_count())
PY
```

Inference endpoint check:
- send one minimal request to the selected Vultr inference target
- redact endpoint identifiers and private response metadata before committing records
- store only lightweight metadata and logs

## Manifest And Artifacts

Use `manifest-template.json` and fill fields from `docs/schemas/experiment-manifest.md`.

Recommended artifact prefix:

```text
dioscuri-cloud/smoke-tests/vultr/<YYYY-MM-DD>/<run_id>/
```

Do not commit model weights, large generated outputs, private telemetry, account screenshots, credentials, local state, or raw provider responses.

## Teardown

Immediately after the smoke workload:
- terminate instances or inference endpoints
- delete unattached disks/volumes unless intentionally retained
- release reserved IPs
- delete load balancers and temporary firewall/network resources
- record public-safe teardown evidence
- update `cost-ledger.md`

## Templates

- Run record: `run-record-template.md`
- Manifest: `manifest-template.json`
- Closeout: `experiments/vultr/closeout-template.md`

## Related Docs

- Bootstrap: `providers/vultr/bootstrap.md`
- GPU go/no-go: `experiments/vultr/gpu-go-no-go/README.md`
- Manifest schema: `docs/schemas/experiment-manifest.md`
- Teardown checklist: `docs/runbooks/teardown-checklist.md`
- Credit closeout: `providers/vultr/credit-closeout.md`
