terraform {
  required_version = ">= 1.3.0"

  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "~> 2.26"
    }
  }
}

provider "vultr" {}

locals {
  metadata = {
    environment                     = "vultr-dev"
    owner                           = var.owner
    provider                        = var.provider_label
    region                          = var.region
    repo                            = var.repo
    resource_name_prefix            = var.resource_name_prefix
    teardown_by                     = var.teardown_by
    enable_no_gpu_smoke_resources   = var.enable_no_gpu_smoke_resources
    enable_gpu_smoke_resources      = var.enable_gpu_smoke_resources
    default_provisions_no_resources = true
  }
}

# This environment is intentionally metadata-only until a reviewed smoke-test
# issue approves specific Vultr resources, costs, runtime caps, and teardown.
