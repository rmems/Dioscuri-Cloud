output "vultr_environment_metadata" {
  description = "Public-safe metadata for the Vultr dev Terraform scaffold."
  value       = local.metadata
}

output "hcp_workspace" {
  description = "Recommended HCP Terraform workspace for this environment."
  value       = "dioscuri-cloud-vultr-dev"
}

output "credential_source" {
  description = "Secret input path expected by the Vultr provider."
  value       = "VULTR_API_KEY environment variable or sensitive HCP Terraform workspace variable"
}
