# Env: oracle-dev

Oracle Cloud dev environment for **hermes-rag** (RAG / MCP stack).

## Resources Managed

- VCN + Subnet
- Security List (SSH + Qdrant 6333 + MCP 8000)
- Compute Instance (`VM.Standard.A1.Flex` – Always Free 4 OCPU / 24 GB)
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

## Usage

```bash
cd terraform/envs/oracle-dev
terraform init
terraform plan
terraform apply
```