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