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
  default     = "rmems"
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
}

variable "enable_gpu_smoke_resources" {
  description = "Opt-in switch for future GPU/inference resources. Must remain false unless explicitly approved."
  type        = bool
  default     = false
}
