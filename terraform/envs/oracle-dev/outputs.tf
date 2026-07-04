output "instance_public_ip" {
  description = "Public IP of the hermes-rag instance (sensitive to reduce attack-surface reconnaissance in CI logs)."
  value       = oci_core_instance.hermes_rag.public_ip
  sensitive   = true
}

output "instance_id" {
  description = "OCID of the hermes-rag instance"
  value       = oci_core_instance.hermes_rag.id
}

output "subnet_id" {
  description = "Subnet OCID"
  value       = oci_core_subnet.hermes_rag.id
}

output "security_list_id" {
  description = "Security List OCID"
  value       = oci_core_security_list.hermes_rag.id
}

output "vcn_id" {
  description = "VCN OCID"
  value       = oci_core_vcn.hermes_rag.id
}

# Credit burn (E5.Flex) outputs for operational access to the temporary high-cost instances
output "burn_instance_public_ips" {
  description = "Public IPs of the credit-burn E5.Flex instances (sensitive)."
  value       = oci_core_instance.burn[*].public_ip
  sensitive   = true
}

output "burn_instance_ids" {
  description = "OCIDs of the credit-burn E5.Flex instances"
  value       = oci_core_instance.burn[*].id
}

output "burn_volume_ids" {
  description = "OCIDs of the credit-burn block volumes"
  value       = oci_core_volume.burn[*].id
}