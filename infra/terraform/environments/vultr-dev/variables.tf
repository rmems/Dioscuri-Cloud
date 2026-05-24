variable "region" {
  description = "Vultr region slug selected for preflight or follow-up smoke tests."
  type        = string
  default     = "ewr"
}

variable "resource_name_prefix" {
  description = "Prefix for any future short-lived Vultr resources."
  type        = string
  default     = "dioscuri-vultr"
}

variable "owner" {
  description = "Owner label for resource attribution."
  type        = string
  default     = "placeholder-owner"
}

variable "repo" {
  description = "Repository label for resource attribution."
  type        = string
  default     = "dioscuri-cloud"
}

variable "provider_label" {
  description = "Provider label used in metadata and tags."
  type        = string
  default     = "vultr"
}

variable "teardown_by" {
  description = "Date by which temporary Vultr resources must be torn down."
  type        = string
  default     = "2026-05-28"
}

variable "enable_no_gpu_smoke_resources" {
  description = "Opt-in switch for future no-GPU resources. Defaults false so validation creates nothing."
  type        = bool
  default     = false

  validation {
    condition     = var.enable_no_gpu_smoke_resources == false
    error_message = "This scaffold contains no no-GPU resource blocks yet; keep enable_no_gpu_smoke_resources false until reviewed resources are added."
  }
}

variable "enable_gpu_smoke_resources" {
  description = "Opt-in switch for future GPU/inference resources. Must remain false unless explicitly approved."
  type        = bool
  default     = false

  validation {
    condition     = var.enable_gpu_smoke_resources == false
    error_message = "This scaffold contains no GPU/inference resource blocks yet; keep enable_gpu_smoke_resources false until a reviewed #38 go decision and approved #39 resource plan add them."
  }
}
