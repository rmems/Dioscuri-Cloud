# Provider Comparison

This comparison is used to decide where Dioscuri-Cloud should run short, bounded ML infrastructure labs. It is planning material only; it does not authorize creating resources.

## Decision Criteria

| Criterion | Why It Matters |
|---|---|
| Credit amount and expiration | Determines how much useful work can be scheduled before a credit window closes. |
| GPU or inference availability | Determines whether SAAQ/MoE smoke tests can run directly or must use API/serverless pivots. |
| Storage and artifact support | Determines where manifests, telemetry, and small checked results can be staged. |
| IAM and Terraform fit | Determines whether infrastructure can become reproducible without leaking credentials. |
| Certification value | Prioritizes providers that also build reusable cloud learning artifacts. |
| Teardown clarity | Reduces risk of accidental spend after short experiments. |

## Current Provider Roles

| Provider | Current Role | Strengths | Constraints | Near-Term Use |
|---|---|---|---|---|
| DigitalOcean | Practical small cloud deployment and possible GPU smoke target. | Simple resources, clear student-credit window, easy teardown. | GPU availability and cost must be checked before use. | Keep for small deployment labs and bounded smoke tests. |
| AWS | Certification-aligned managed ML and storage practice. | SageMaker, S3, IAM, ECR, mature budget controls. | Services can become expensive quickly without strict caps. | Use for short managed ML and S3/ECR/IAM labs. |
| Azure | Certification-aligned Azure ML and resource-group practice. | Azure ML, Blob, Key Vault, resource groups, strong teardown grouping. | Credit amount is smaller than other providers. | Use for same-day smoke tests and certification labs. |
| GCP / Vertex AI | Managed AI platform practice. | Vertex AI and Gemini ecosystem alignment. | Monthly credit is small, so experiments must be light. | Use only for tiny inference/storage validation. |
| IBM Cloud / watsonx | watsonx trial and agent/research workflow experiments. | watsonx.ai, Code Engine, Object Storage, agent tooling options. | Some services may be business-email gated or region limited. | Use for watsonx notes, synthetic data, and research-agent prototypes. |
| Oracle Cloud | Persistent free-tier and lightweight service hosting. | ARM/free-tier compute, object storage, database/vector/RAG options. | Quota and capacity vary by region. | Use for always-on MCP, telemetry, and lightweight Rust services. |
| Vultr | Completed serverless inference sprint; inactive for near-term execution. | OpenAI-compatible serverless API was useful during the finished credit sprint. | Promo credit is closed out and GPU capacity/auth gates blocked earlier planned GPU work. | Keep records only; do not upload/configure Vultr API keys or schedule Vultr runs for now. |
| HashiCorp / HCP Terraform | Control plane for reproducible infrastructure. | Workspace naming, VCS workflows, remote plans. | Not a model compute provider. | Use for Terraform workflow and state discipline. |

## Execution Preference

1. Prefer documentation and provider-neutral planning before creating resources.
2. Prefer providers with active credits and clear teardown evidence paths.
3. Prefer managed/serverless services for short inference checks when GPU capacity is unavailable.
4. Treat Vultr as closeout-only for now; do not upload/configure Vultr API credentials or plan new Vultr runs unless a future issue explicitly reactivates the provider.
