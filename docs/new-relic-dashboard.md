# New Relic Dashboard Plan

Planned dashboards for SAAQ cloud lab observability:

1. **SAAQ Run Health**
2. **Cloud GPU Cost + Performance**
3. **Model Lineup Quality**
4. **Failure Taxonomy**

## Safe fields (allowlist)
- `run_id`
- `git_sha`
- `model_slug`
- `provider`
- `cloud_provider`
- `region`
- `gpu_type`
- `saaq_version`
- `telemetry_source`
- `heartbeat_enabled`
- `latency_ms`
- `runtime_seconds`
- `success`
- `error_category`
- `estimated_cost_usd`
- `artifact_count`

## Explicitly excluded fields (denylist)
- secrets
- DSNs
- API keys
- raw telemetry rows
- model weights
- prompts
- absolute local checkpoint paths
- local usernames
