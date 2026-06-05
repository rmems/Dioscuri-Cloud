# Env: oracle-dev

Oracle Cloud dev environment skeleton.

HCP Terraform:
- Organization: `Limen-Neural`
- Workspace: `dioscuri-cloud-oracle-dev`
- Working directory: `terraform/envs/oracle-dev`

TODO:
- Define OCI provider configuration via HCP sensitive variables (see `docs/hcp/provider-variable-map.md`).
- Implement `artifact_bucket` using OCI Object Storage.
- Implement `service_account` using OCI IAM policies.
- Add a `cost-ledger.md` row before any billable resource.

CLI preflight: `providers/oracle/bootstrap.md`.
