# Certification And Lab Map

This map connects Dioscuri-Cloud lab work to cloud learning tracks. It is intended for planning future issues and runbooks, not for asserting completed certifications.

## Lab Families

| Lab Family | Repo Artifacts | Certification / Learning Alignment |
|---|---|---|
| Cloud fundamentals | `providers/*/README.md`, `providers/*/bootstrap.md` | Account setup, regions, IAM, resource groups/projects/compartments, tagging, budget controls. |
| Infrastructure as code | `terraform/`, `infra/terraform/`, `docs/hcp/` | Terraform workflow, remote execution, workspace naming, provider variables, state hygiene. |
| Managed ML | `providers/aws/`, `providers/azure/`, `providers/ibm/`, `docs/cloud-gpu-runbook.md` | SageMaker, Azure ML, watsonx.ai, managed endpoints, model evaluation. |
| Artifact storage | `docs/artifact-storage-plan.md`, `docs/schemas/experiment-manifest.md` | Object storage, lifecycle policy, artifact classification, data retention. |
| Cost and teardown | `cost-ledger.md`, `docs/credits/`, `docs/runbooks/teardown-checklist.md` | Budgeting, resource hygiene, billing review, audit evidence. |
| Lightweight services | `providers/oracle/README.md`, future Oracle/DO run records | Always-on services, container/VM deployment, service monitoring, API hosting. |
| Agent and RAG systems | `providers/ibm/README.md`, `providers/oracle/README.md`, future experiment records | watsonx, vector stores, retrieval services, evaluation harnesses, telemetry. |

## Provider-Specific Map

| Provider | First Lab | Follow-On Lab | Learning Outcome |
|---|---|---|---|
| AWS | Managed ML smoke-test runbook review. | S3 artifact bucket and SageMaker/ECR bounded smoke test. | IAM, S3, SageMaker, cost controls. |
| Azure | Azure ML smoke-test runbook review. | Resource-group-scoped Azure ML and Blob artifact upload. | Resource groups, Azure ML, Blob, Key Vault. |
| DigitalOcean | Object-storage/no-GPU smoke test. | Small app deployment or GPU availability check. | Simple deployments, object storage, teardown discipline. |
| GCP / Vertex AI | Tiny managed inference or metadata-only planning. | Vertex AI evaluation harness if monthly cap permits. | Vertex AI basics under strict credit limits. |
| IBM Cloud / watsonx | watsonx onboarding and service inventory. | Research-agent or synthetic-data pipeline prototype. | watsonx.ai, Code Engine, Object Storage, agent tooling. |
| Oracle Cloud | Trial onboarding and region/quota inventory. | Always-on MCP or lightweight Rust telemetry service. | OCI compute, ARM/free-tier options, object storage, database/vector services. |
| Vultr | Credit closeout and serverless inference retrospective. | Future GPU gate only if auth/capacity checks pass. | Provider fallback planning and closeout discipline. |

## Planning Rules

- Each new lab should create or update one durable repo artifact.
- Each billable lab must update `cost-ledger.md`.
- Each execution lab must include teardown evidence or an explicit retained-resource reason.
- Labs that depend on another repo should link the owning repo rather than duplicating implementation details here.
