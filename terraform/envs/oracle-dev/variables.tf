variable "location" {
  description = "OCI region for artifacts."
  type        = string
}

variable "artifact_bucket_name" {
  description = "Artifact bucket name."
  type        = string
}

variable "service_account_name" {
  description = "Service account/principal name for artifact access."
  type        = string
}
