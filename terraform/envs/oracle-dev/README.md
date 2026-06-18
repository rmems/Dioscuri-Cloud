# Env: oracle-dev

Oracle Cloud dev environment for **hermes-rag** (RAG / MCP stack).

## Resources Managed

- VCN + Subnet + Internet Gateway + Route Table
- Security List with restricted ingress (SSH + Qdrant 6333 + MCP 8000 from `var.operator_cidrs`)
- Compute Instance (`VM.Standard.A1.Flex` – Always Free 4 OCPU / 24 GB, 100 GB boot volume)
- Artifact bucket + service account (existing modules)

## Required HCP Workspace Variables (sensitive)

- `tenancy_ocid`
- `user_ocid`
- `fingerprint`
- `private_key`
- `compartment_ocid`
- `availability_domain`
- `ubuntu_image_id`
- `ssh_public_key`
- **`operator_cidrs`** (list of strings) — must be set to the operator's actual VPN/office CIDRs; the default `["10.0.0.0/8"]` is a non-routable example and will not match real public IPs. **In HCP Terraform, mark this variable as HCL** (or pass it as a JSON list literal) so type conversion succeeds. A `validation` block in `variables.tf` will reject the dummy default `10.0.0.0/8` if the workspace variable is not overridden.

## Usage

```bash
cd terraform/envs/oracle-dev
terraform init

# PREREQUISITE: update cost-ledger.md with the new resource row(s) before apply
# (see repository docs/credits/usage-policy.md and cost-ledger.md for the format).

terraform plan
terraform apply
```

> **Required:** A `cost-ledger.md` row must exist for the new compute + networking resources before the first `terraform apply`. The repo policy (see `docs/credits/usage-policy.md:5-24`) requires estimate, owner/issue context, and teardown tracking in the same PR as the resource creation.