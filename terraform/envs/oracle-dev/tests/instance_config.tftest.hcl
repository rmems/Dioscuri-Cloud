# Tests for the oci_core_instance.hermes_rag resource changes added in main.tf.
#
# This PR added preserve_boot_volume = false to the instance resource, ensuring
# that the boot volume is automatically deleted when the instance is terminated
# so no orphaned storage is left behind.
#
# Run with: terraform -chdir=terraform/envs/oracle-dev test
#           (requires Terraform >= 1.7 for mock_provider support)

mock_provider "oci" {}

# ── Shared baseline variables ──────────────────────────────────────────────────

variables {
  tenancy_ocid        = "ocid1.tenancy.oc1..aaaaatest"
  user_ocid           = "ocid1.user.oc1..aaaaatest"
  fingerprint         = "aa:bb:cc:dd:ee:ff:00:11:22:33:44:55:66:77:88:99"
  private_key         = "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAtest\n-----END RSA PRIVATE KEY-----"
  compartment_ocid    = "ocid1.compartment.oc1..aaaaatest"
  availability_domain = "MQUI:PHX-AD-1"
  ubuntu_image_id     = "ocid1.image.oc1.phx.aaaaatest"
  ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAA test@host"
  operator_cidrs      = ["203.0.113.0/24"]
}

# ─────────────────────────────────────────────────────────────────────────────
# preserve_boot_volume is explicitly set to false
# ─────────────────────────────────────────────────────────────────────────────

run "instance_preserve_boot_volume_is_false" {
  # After the PR change, preserve_boot_volume must be false on the instance so
  # that terminated instances do not leave orphaned boot volumes in OCI.
  command = apply

  assert {
    condition     = oci_core_instance.hermes_rag.preserve_boot_volume == false
    error_message = "preserve_boot_volume must be false; a true value would leave orphaned boot volumes on instance termination"
  }
}

run "instance_shape_is_always_free_ampere" {
  # Regression guard: shape must remain VM.Standard.A1.Flex (Always Free tier).
  # Changing the shape would incur unexpected charges.
  command = apply

  assert {
    condition     = oci_core_instance.hermes_rag.shape == "VM.Standard.A1.Flex"
    error_message = "Shape must be VM.Standard.A1.Flex (Always Free Ampere); other shapes incur charges"
  }
}

run "instance_display_name_is_hermes_rag" {
  # Regression guard: display name must stay "hermes-rag" so existing automation
  # and tagging policies that reference it by name continue to work.
  command = apply

  assert {
    condition     = oci_core_instance.hermes_rag.display_name == "hermes-rag"
    error_message = "Instance display name must be 'hermes-rag'"
  }
}