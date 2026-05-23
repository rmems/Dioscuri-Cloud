variable "location" {
  description = "GCP bucket location (region or multi-region, provider-specific)."
  type        = string
}

variable "artifact_bucket_name" {
  description = "Artifact bucket name."
  type        = string
}

variable "service_account_name" {
  description = "Service account name for artifact access."
  type        = string
}
