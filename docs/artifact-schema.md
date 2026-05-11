# Artifact Schema

Expected artifact layout for both cloud and local smoke runs:

```text
<run_root>/
  run_manifest.json
  artifacts/index.csv
  logs/
  metrics/
  results.md
```

## File expectations
- `run_manifest.json`: canonical run metadata and provenance.
- `artifacts/index.csv`: index of generated artifacts and checksums/paths (sanitized).
- `logs/`: runtime logs safe for sharing.
- `metrics/`: summarized metrics for comparison.
- `results.md`: human-readable summary, outcomes, and teardown confirmation.

## Example `run_manifest.json`

```json
{
  "run_id": "TBD-run-001",
  "git_sha": "TBD",
  "model_slug": "TBD",
  "provider": "TBD",
  "region": "TBD",
  "gpu_type": "TBD",
  "instance_type": "TBD",
  "saaq_version": "TBD",
  "telemetry_source": "TBD",
  "heartbeat_enabled": false,
  "start_time_utc": "TBD",
  "end_time_utc": "TBD",
  "runtime_seconds": null,
  "estimated_cost_usd": null,
  "artifacts": [
    "artifacts/index.csv",
    "logs/",
    "metrics/",
    "results.md"
  ],
  "teardown_confirmed": "TBD",
  "notes": "Placeholder manifest; replace with evidence-backed values only."
}
```