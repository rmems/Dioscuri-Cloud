terraform {
  required_version = ">= 1.3.0"
}

// HCP workspace: dioscuri-cloud-hcp-core (org Limen-Neural).
// Control-plane onboarding only; see docs/hcp/workspaces.md.

module "onboarding_baseline" {
  source = "../../modules/onboarding_baseline"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner
}
