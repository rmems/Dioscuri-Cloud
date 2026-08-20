# Training artifact layout

Canonical object-storage paths for cloud AI **training** runs. Implementations: GitHub #47 (bucket), #52 (contract), #53/#54 (jobs).

**No model weights** in these buckets — stage weights at runtime via a separate path. No secrets in git.

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
        latest -> step_<n>/
    logs/
      <run_id>/
        metrics.json
        events/          # optional TensorBoard
    manifests/
      <run_id>.json
      index.json         # optional append-only run index
```

## Manifest

See `docs/schemas/experiment-manifest.md` (training fields) and `examples/training-run-manifest.synthetic.json`.

## Provider neutrality

Use the same key layout on AWS S3 (primary), Azure Blob (backup), and other backends. URIs in manifests use `s3://` or `https://` forms without account IDs in git.
