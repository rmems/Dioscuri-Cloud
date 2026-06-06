variable "location" {
  description = "IBM region/location for artifacts."
  type        = string
  default     = "us-south"
}

variable "artifact_bucket_name" {
  description = "Artifact bucket name."
  type        = string
  default     = "dioscuri-cloud-dev-artifacts"
}

variable "service_account_name" {
  description = "Service account/principal name for artifact access."
  type        = string
  default     = "dioscuri-artifact-reader"
}
