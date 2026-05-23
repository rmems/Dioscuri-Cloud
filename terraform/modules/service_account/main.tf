terraform {
  required_version = ">= 1.3.0"
}

// TODO(provider-specific): implement for GCP (service accounts), IBM (service IDs), AWS (IAM roles/users), Azure (service principals).
// Prefer workload identity / OIDC in env composition where possible.
