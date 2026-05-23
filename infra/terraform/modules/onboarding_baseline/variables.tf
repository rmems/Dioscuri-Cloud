variable "project_name" {
  description = "Logical project name for the onboarding environment."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, staging, or prod."
  type        = string
}

variable "owner" {
  description = "Primary owner or team label for the onboarding environment."
  type        = string
}

variable "target_providers" {
  description = "Provider list this scaffold is expected to support later."
  type        = list(string)
  default     = ["ibm", "gcp", "do", "aws", "azure"]
}
