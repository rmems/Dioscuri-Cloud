terraform {
  required_version = ">= 1.3.0"
}

locals {
  onboarding_metadata = {
    environment = var.environment
    project     = var.project_name
    providers   = var.target_providers
    owner       = var.owner
  }
}
