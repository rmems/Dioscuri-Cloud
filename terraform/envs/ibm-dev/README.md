# Env: ibm-dev

IBM Cloud dev environment skeleton.

HCP Terraform:
- Organization: `Limen-Neural`
- Workspace: `dioscuri-cloud-ibm-dev`
- Working directory: `terraform/envs/ibm-dev`

TODO:
- Define IBM provider configuration via HCP sensitive variables (see `docs/hcp/provider-variable-map.md`).
- Implement `artifact_bucket` using IBM Cloud Object Storage.
- Implement `service_account` using IBM service IDs + IAM policies.
- Add a `cost-ledger.md` row before any billable resource.

CLI preflight: `providers/ibm/bootstrap.md`.
