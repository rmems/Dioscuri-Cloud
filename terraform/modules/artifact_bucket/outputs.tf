output "name" {
  description = "Bucket/container name."
  value       = var.name
}

output "location" {
  description = "Bucket/container location/region."
  value       = var.location
}

// TODO(provider-specific): add outputs for canonical URL/ARN/self_link once resources exist.
