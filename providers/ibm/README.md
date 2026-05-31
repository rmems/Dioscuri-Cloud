# IBM Cloud And watsonx Onboarding

IBM Cloud is currently assigned to watsonx, research-agent, synthetic-data, and object-storage experiments for Dioscuri-Cloud.

## Credit And Trial Status

| Item | Status | Notes |
|---|---|---|
| IBM Cloud credit | Claimed: `$200` | Track spend in `cost-ledger.md` before creating billable resources. |
| watsonx free trial | Activated | Use for managed AI, agent, and evaluation experiments where available. |

## Account And Region Notes

- Use the IBM Cloud console for account/resource-group setup.
- Select one initial region and keep early experiments in that region for easier teardown.
- Use a dedicated resource group such as `dioscuri-cloud`.
- Do not commit API keys, service credential names, account IDs, billing screenshots, or private resource IDs.
- Store credentials only in local environment variables, HCP Terraform sensitive variables, or provider-managed secret stores.

## Useful Services

| Service | Dioscuri-Cloud Use |
|---|---|
| watsonx.ai | Managed model evaluation, prompt tests, synthetic data, and research-agent prototypes. |
| watsonx Orchestrate / agent tooling | Agent workflow exploration if accessible in the trial. |
| Code Engine | Short-lived container jobs and lightweight services. |
| Cloud Object Storage | Experiment manifests, telemetry samples, and public-safe reports. |
| Kubernetes / OpenShift options | Later container orchestration labs only after cost guardrails are clear. |
| Vector / retrieval services | RAG or SAAQ assistant prototypes if available under the account/trial. |

## First Experiment Ideas

| Idea | Output Artifact | Guardrail |
|---|---|---|
| Research-agent prototype | `experiments/ibm/<date>-research-agent.md` | Keep prompts and outputs public-safe. |
| Synthetic data pipeline | `experiments/ibm/<date>-synthetic-data.md` | No sensitive/private source data. |
| SAAQ/RAG assistant | `experiments/ibm/<date>-saaq-rag-assistant.md` | Reference downstream repos instead of duplicating SAAQ internals. |
| Model evaluation harness | `experiments/ibm/<date>-model-eval.md` | Cap runtime and token spend before execution. |

## Known Constraints To Check

- Some watsonx or agent services may require business-email or account eligibility checks.
- Region availability may differ between IBM Cloud services and watsonx services.
- Free-trial quotas should be verified before any run that could incur overage.

## Related Files

- Bootstrap runbook: `providers/ibm/bootstrap.md`
- Provider strategy: `docs/cloud-credit-strategy.md`
- Artifact plan: `docs/artifact-storage-plan.md`
- Cost ledger: `cost-ledger.md`
