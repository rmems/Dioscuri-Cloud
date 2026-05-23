variable "name" {
  description = "Service account/principal name (provider-specific constraints apply)."
  type        = string
}

variable "description" {
  description = "Description for the principal (where supported)."
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels/tags to apply where supported."
  type        = map(string)
  default     = {}
}

variable "roles" {
  description = "List of provider-specific role identifiers to bind/attach (implementation deferred)."
  type        = list(string)
  default     = []
}
