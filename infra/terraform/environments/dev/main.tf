terraform {
  required_version = ">= 1.3.0"
}

module "onboarding_baseline" {
  source = "../../modules/onboarding_baseline"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner
}
