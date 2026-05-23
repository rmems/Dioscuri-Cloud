output "project_name" {
  description = "Project name for the onboarding environment."
  value       = var.project_name
}

output "environment" {
  description = "Environment name."
  value       = var.environment
}

output "owner" {
  description = "Owner or team label for the onboarding environment."
  value       = var.owner
}

output "target_providers" {
  description = "Provider list targeted by future onboarding work."
  value       = var.target_providers
}

output "metadata" {
  description = "Provider-neutral onboarding metadata."
  value       = local.onboarding_metadata
}
