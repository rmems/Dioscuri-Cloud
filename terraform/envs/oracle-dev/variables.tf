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
  description = "OCI Region (canonical). Required. Falls back to var.location for backward compatibility with HCP workspaces that set OCI_LOCATION."
  type        = string
  default     = null
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
  description = "Ubuntu 24.04 ARM image OCID (used by hermes-rag A1.Flex)"
  type        = string
}

variable "ubuntu_x86_image_id" {
  description = "Ubuntu 24.04 x86_64 (AMD64) image OCID (used by E5.Flex credit-burn instance)"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key content for the instance"
  type        = string
  sensitive   = true
}

variable "operator_cidrs" {
  description = "List of operator source CIDRs allowed to reach SSH/Qdrant/MCP. REQUIRED: HCP workspaces must set this to the operator's actual VPN/office CIDRs (e.g. [\"203.0.113.0/24\"]); the default is a non-routable example and will not match real operator IPs. In HCP Terraform the variable must be marked HCL (see README.md)."
  type        = list(string)
  default     = ["10.0.0.0/8"]

  validation {
    condition     = length(var.operator_cidrs) > 0 && !contains(var.operator_cidrs, "10.0.0.0/8")
    error_message = "operator_cidrs must be set to real operator VPN/office CIDRs; the default 10.0.0.0/8 is a non-routable example and will lock out all access. See README.md for the full setup path."
  }
}

# Existing variables kept for compatibility
variable "location" {
  description = "Deprecated alias for var.region. Kept for backward compatibility with existing HCP workspace variables that set OCI_LOCATION. Prefer var.region in new code."
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