terraform {
  required_version = ">= 1.3.0"
}

locals {
  onboarding_metadata = {
    environment      = var.environment
    project_name     = var.project_name
    target_providers = var.target_providers
    owner            = var.owner
  }
}
