# Cloud Credit Strategy

This strategy turns the current credit portfolio into explicit provider roles so future experiments can be scheduled without relying on chat-only context.

## Current Credit Position

| Provider | Credit / Trial | Status | Role |
|---|---:|---|---|
| Vultr | `$250` promo credit | Closed out on `2026-05-28`; `$237.31` consumed and `$12.69` expired. | Historical serverless inference sprint only; inactive for near-term execution. |
| IBM Cloud | `$200` cloud credit | Claimed. | watsonx, research-agent prototypes, synthetic data pipeline, object storage evaluation. |
| IBM watsonx | Free trial | Activated. | Managed AI and agent/evaluation experiments. |
| Oracle Cloud | `$300` free trial | Claimed. | Persistent services, MCP hosting, telemetry ingestion, object storage, vector/RAG backend. |
| DigitalOcean | Student credits | Active per inventory. | Simple deployments and possible bounded GPU smoke tests. |
| AWS | Student credits | Active per inventory. | Certification-aligned managed ML and storage labs. |
| Azure | Student credits | Active per inventory. | Certification-aligned Azure ML/resource-group labs. |
| GCP | Google AI Pro monthly credit | Monthly. | Tiny inference and metadata-only experiments. |

## Provider Roles

| Role | Primary Provider | Backup Provider | Notes |
|---|---|---|---|
| Managed AI / agent prototypes | IBM watsonx | GCP / Vertex AI | Keep payloads small and record service limits. |
| Always-on lightweight services | Oracle Cloud | DigitalOcean | Favor free-tier/low-cost instances with explicit teardown or retained-resource notes. |
| Certification labs | AWS, Azure | IBM Cloud | Align labs to IAM, storage, managed ML, and budget controls. |
| Artifact storage | IBM COS, Oracle Object Storage, AWS S3 | Azure Blob, DO Spaces | Implement only after `docs/artifact-storage-plan.md` is mapped to provider resources. |
| GPU or inference bursts | DigitalOcean, AWS, Azure | IBM/GCP managed services where credits fit | Vultr is not in the active near-term execution path. |

## Scheduling Rules

1. Use expiring credits first only when the run has a bounded queue and teardown plan.
2. Record every billable run in `cost-ledger.md`.
3. Prefer the smallest provider-native experiment that produces a durable repo artifact.
4. Avoid full-model Grok-1 work in this repo; this repo may only record gates, cloud setup, and run metadata owned by downstream repos.
5. Do not upload, configure, or commit Vultr API material unless a future issue explicitly reactivates Vultr.
