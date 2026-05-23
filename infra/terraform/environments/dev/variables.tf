variable "project_name" {
  description = "Logical project name for this environment."
  type        = string
  default     = "dioscuri-cloud"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner or team label for this environment."
  type        = string
  default     = "raulmc"
}
