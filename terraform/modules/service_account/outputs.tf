output "name" {
  description = "Principal name."
  value       = var.name
}

// TODO(provider-specific): output stable identifiers once resources exist:
// - email (GCP)
// - id/uuid (IBM)
// - arn (AWS)
// - object_id/client_id (Azure)
