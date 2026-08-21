# Training artifact layout

Canonical object-storage paths for cloud AI **training** runs. Implementations: GitHub #47 (bucket), #52 (contract), #53/#54 (jobs).

**Do not store staged base-model weights** (downloaded GGUF/safetensors/HF snapshots used as input) in these buckets. Stage those at runtime via a separate path. **Do store generated run checkpoints** under `training/checkpoints/<run_id>/` (optimizer/model state produced by the job). No secrets in git.

## Bucket prefix

```text
<training-bucket>/
  training/
    datasets/
      <dataset_slug>/
        manifest.json
        shards/...
    checkpoints/
      <run_id>/
        step_<n>/...
        latest.json          # pointer: {"checkpoint_prefix": "training/checkpoints/<run_id>/step_<n>/"}
    logs/
      <run_id>/
        metrics.json
        events/          # optional TensorBoard
    manifests/
      <run_id>.json
      index.json         # optional append-only run index
```

`latest.json` is an object-store pointer, not a filesystem symlink. S3 and Azure Blob have keys, not `ln -s`. `checkpoint_uri` in the run manifest should be the prefix of the latest completed step (the same value as `checkpoint_prefix` in `latest.json`).

## Manifest

See `docs/schemas/experiment-manifest.md` (training fields) and `examples/training-run-manifest.synthetic.json`.

## Provider neutrality

Use the same key layout on AWS S3 (primary), Azure Blob (backup), and other backends. URIs in manifests use `s3://` or `https://` forms without account IDs in git.
