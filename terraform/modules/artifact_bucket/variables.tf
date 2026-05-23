variable "name" {
  description = "Bucket/container name (provider-specific constraints apply)."
  type        = string
}

variable "location" {
  description = "Region/location for the bucket/container (provider-specific)."
  type        = string
}

variable "labels" {
  description = "Labels/tags to apply where supported."
  type        = map(string)
  default     = {}
}

variable "versioning" {
  description = "Enable object versioning where supported."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow bucket deletion even if non-empty (dangerous; default false)."
  type        = bool
  default     = false
}
