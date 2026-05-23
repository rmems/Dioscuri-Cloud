output "project_name" {
  description = "Project name for the dev onboarding environment."
  value       = module.onboarding_baseline.project_name
}

output "environment" {
  description = "Environment name for the dev onboarding environment."
  value       = module.onboarding_baseline.environment
}

output "target_providers" {
  description = "Providers targeted by later onboarding work."
  value       = module.onboarding_baseline.target_providers
}

output "owner" {
  description = "Owner or team label for the dev onboarding environment."
  value       = module.onboarding_baseline.owner
}
