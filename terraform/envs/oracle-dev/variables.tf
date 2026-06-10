variable "tenancy_ocid" {
  description = "OCI Tenancy OCID"
  type        = string
  sensitive   = true
}

variable "user_ocid" {
  description = "OCI User OCID"
  type        = string
  sensitive   = true
}

variable "fingerprint" {
  description = "OCI API Key Fingerprint"
  type        = string
  sensitive   = true
}

variable "private_key" {
  description = "OCI API Private Key (PEM)"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "OCI Region"
  type        = string
  default     = "us-phoenix-1"
}

variable "compartment_ocid" {
  description = "Compartment OCID for hermes-rag resources"
  type        = string
  sensitive   = true
}

variable "availability_domain" {
  description = "Availability Domain (e.g. MQUI:PHX-AD-1)"
  type        = string
}

variable "ubuntu_image_id" {
  description = "Ubuntu 24.04 ARM image OCID"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key content for the instance"
  type        = string
}

# Existing variables kept for compatibility
variable "location" {
  description = "OCI region for artifacts."
  type        = string
  default     = "us-phoenix-1"
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