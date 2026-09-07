# Experiment tracking for training runs

Tracks training metrics and run history in the artifact bucket itself
(GitHub #60) — not a shared RAG vector database, and not a paid managed
experiment-tracking platform unless separately cap-approved in an issue.

The contract this relies on is defined in `docs/training/artifact-layout.md`
("Metrics and run index" section): every run writes
`training/logs/<run_id>/metrics.json` and a run manifest at
`training/manifests/<run_id>.json`; buckets may additionally maintain
`training/manifests/index.json` as a lightweight cross-run index.

## Comparing two training smokes

Two runs can be compared **from stored artifacts alone** — no external
tracker required.

1. Fetch both run manifests:
   ```bash
   aws s3 cp s3://<bucket>/training/manifests/<run_id_a>.json .
   aws s3 cp s3://<bucket>/training/manifests/<run_id_b>.json .
   ```
2. Fetch both metrics files:
   ```bash
   aws s3 cp s3://<bucket>/training/logs/<run_id_a>/metrics.json metrics_a.json
   aws s3 cp s3://<bucket>/training/logs/<run_id_b>/metrics.json metrics_b.json
   ```
3. Compare the fields that matter for a smoke-to-smoke comparison:

   | Dimension | Manifest field | Metrics field |
   |---|---|---|
   | Step loss | — | `final_loss` (or last entry in `steps`) |
   | Wall time | — | `wall_time_seconds` |
   | Cost | `estimated_cost_usd` / `actual_cost_usd` | — |
   | Steps completed | `steps_completed` | `final_step` |
   | Trainer/base model | `trainer`, `base_model` | — |

   A one-line `jq` comparison, for example:
   ```bash
   jq -s '.[0].final_loss as $a | .[1].final_loss as $b | {a: $a, b: $b, delta: ($b - $a)}' \
     metrics_a.json metrics_b.json
   ```

If a bucket maintains `training/manifests/index.json`, skip steps 1–2 and
query it directly — it already carries `final_loss`, `wall_time_seconds`,
`steps_completed`, and both cost fields per run.

## What "comparable" means here

This is a smoke-to-smoke sanity comparison (did the second run improve on
the first, roughly how much did it cost, how long did it take) — not
statistical benchmarking. If you need repeated runs, parameter sweeps, or
profiling, that's a "real experiment" per
`docs/runbooks/gpu-smoke-test-readiness.md` and should be scoped as its own
issue with explicit cost and teardown expectations, not folded into this
lightweight tracking path.

## Non-goals

- No shared RAG vector database or IDE-tool integration.
- No paid managed experiment-tracking platform (e.g. Weights & Biases,
  Neptune) unless cap-approved in a specific issue per
  `docs/credits/usage-policy.md`.
