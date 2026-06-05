terraform {
  required_version = ">= 1.3.0"
}

// Provider configuration and resource implementations are intentionally deferred.
// HCP workspace: dioscuri-cloud-ibm-dev (org Dioscuri-Cloud).
// See providers/ibm/bootstrap.md and docs/hcp/provider-variable-map.md.

module "artifacts" {
  source = "../../modules/artifact_bucket"

  name     = var.artifact_bucket_name
  location = var.location

  labels = {
    env = "dev"
  }
}

module "artifact_sa" {
  source = "../../modules/service_account"

  name        = var.service_account_name
  description = "Artifact access principal (IBM dev)"

  roles = []
}
