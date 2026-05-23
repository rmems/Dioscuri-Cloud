output "artifact_bucket_name" {
  description = "Artifact bucket name."
  value       = module.artifacts.name
}

output "service_account_name" {
  description = "Artifact principal name."
  value       = module.artifact_sa.name
}
