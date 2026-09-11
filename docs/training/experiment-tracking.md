# Experiment tracking for training runs

Tracks training metrics and run history in the artifact bucket itself
(GitHub #60) — not a shared RAG vector database, and not a paid managed
experiment-tracking platform unless separately cap-approved in an issue.

The comparison workflow below uses the contract in
`docs/training/artifact-layout.md` ("Metrics and run index" section).
Issue #60 allows a run to produce `metrics.json` **or** TensorBoard
event files. TensorBoard-only runs remain valid stored artifacts, but
this workflow compares only runs that also write
`training/logs/<run_id>/metrics.json` (plus a run manifest at
`training/manifests/<run_id>.json`). Buckets may additionally maintain
`training/manifests/index.json` as a lightweight cross-run index.

This workflow requires the small structured `metrics.json` specifically —
parsing TensorBoard's binary event format for a two-line loss/wall-time
diff would defeat "comparable from stored artifacts alone." A
TensorBoard-only run isn't comparable here until it also writes a
`metrics.json` summary (even a minimal one, generated from the same
event data).

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

   A `jq` comparison, handling `final_loss: null` (permitted by the
   schema, e.g. for trainers that don't report a scalar loss) rather than
   erroring on the subtraction:
   ```bash
   jq -s '.[0].final_loss as $a | .[1].final_loss as $b |
     if ($a == null or $b == null)
     then {a: $a, b: $b, delta: "not comparable (null final_loss)"}
     else {a: $a, b: $b, delta: ($b - $a)} end' \
     metrics_a.json metrics_b.json
   ```
   If `final_loss` is null but a `steps` array is present, use the last
   entry's `loss` instead (`.steps[-1].loss`) in place of `.final_loss`
   above.

If a bucket maintains `training/manifests/index.json`, skip steps 1–2 and
query it directly for dimensions the index already carries: `trainer`,
`base_model`, `final_loss`, `wall_time_seconds`, `steps_completed`, and
both cost fields. Index entries do **not** include the per-run `steps`
array, so the `.steps[-1].loss` fallback above is unavailable on this
path. A run whose `final_loss` is null still needs its per-run
`metrics.json` (step 2) to compare step loss.

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
