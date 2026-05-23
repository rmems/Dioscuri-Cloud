terraform {
  required_version = ">= 1.3.0"
}

// Provider configuration and resource implementations are intentionally deferred.
// This environment composes stable module interfaces and will gain provider wiring in a follow-up issue.

module "artifacts" {
  source = "../../modules/artifact_bucket"

  name     = var.artifact_bucket_name
  location = var.location

  labels = {
    env = "artifacts"
  }
}

module "artifact_sa" {
  source = "../../modules/service_account"

  name        = var.service_account_name
  description = "Artifact access service account (GCP)"

  roles = []
}
