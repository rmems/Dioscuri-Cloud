variable "location" {
  description = "OCI region for artifacts."
  type        = string
  default     = "us-phoenix-1"
}

variable "artifact_bucket_name" {
  description = "Artifact bucket name. Default matches the bucket bootstrapped manually via OCI CLI (see experiments/oracle/2026-06-04-object-storage-bootstrap.md). When the OCI provider block is added (#48), terraform import the existing bucket before the first apply."
  type        = string
  default     = "dioscuri-cloud-dev-artifacts"
}

variable "service_account_name" {
  description = "Service account/principal name for artifact access."
  type        = string
  default     = "dioscuri-artifact-reader"
}
