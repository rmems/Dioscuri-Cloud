# Tests for the operator_cidrs validation block added in variables.tf.
#
# The validation rejects:
#   - the dummy default "10.0.0.0/8"
#   - any list that contains "10.0.0.0/8"
#   - an empty list (length == 0)
#
# Run with: terraform -chdir=terraform/envs/oracle-dev test
#           (requires Terraform >= 1.7 for mock_provider support)

mock_provider "oci" {}

# ── Shared baseline variables (all required inputs, valid operator_cidrs) ──────

variables {
  tenancy_ocid        = "ocid1.tenancy.oc1..aaaaatest"
  user_ocid           = "ocid1.user.oc1..aaaaatest"
  fingerprint         = "aa:bb:cc:dd:ee:ff:00:11:22:33:44:55:66:77:88:99"
  private_key         = "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAtest\n-----END RSA PRIVATE KEY-----"
  compartment_ocid    = "ocid1.compartment.oc1..aaaaatest"
  availability_domain = "MQUI:PHX-AD-1"
  ubuntu_image_id     = "ocid1.image.oc1.phx.aaaaatest"
  ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAA test@host"
  # operator_cidrs is overridden per run block below
  operator_cidrs = ["203.0.113.0/24"]
}

# ─────────────────────────────────────────────────────────────────────────────
# Valid inputs — validation must NOT raise an error
# ─────────────────────────────────────────────────────────────────────────────

run "valid_single_cidr_passes_validation" {
  # A single non-10.0.0.0/8 CIDR should satisfy both conditions:
  # length > 0 AND no "10.0.0.0/8" element.
  command = plan

  variables {
    operator_cidrs = ["203.0.113.0/24"]
  }
}

run "valid_multiple_cidrs_pass_validation" {
  # Multiple CIDRs, none of which is "10.0.0.0/8", should pass.
  command = plan

  variables {
    operator_cidrs = ["203.0.113.0/24", "198.51.100.0/24"]
  }
}

run "valid_host_cidr_passes_validation" {
  # /32 host CIDRs are legitimate operator entries and must pass.
  command = plan

  variables {
    operator_cidrs = ["203.0.113.42/32"]
  }
}

run "valid_ipv6_like_range_with_real_ipv4_passes" {
  # Edge case: list contains the 192.0.2.0/24 documentation range — still valid
  # as far as the validation is concerned (it only blocks 10.0.0.0/8).
  command = plan

  variables {
    operator_cidrs = ["192.0.2.0/24"]
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# Invalid inputs — validation MUST raise an error
# ─────────────────────────────────────────────────────────────────────────────

run "rejects_default_placeholder_cidr" {
  # The dummy default ["10.0.0.0/8"] must be rejected so that workspaces that
  # forget to override the variable fail loudly at plan time.
  command = plan

  variables {
    operator_cidrs = ["10.0.0.0/8"]
  }

  expect_failures = [var.operator_cidrs]
}

run "rejects_list_containing_placeholder_alongside_real_cidrs" {
  # Even if a real CIDR is present, the list must be rejected when it also
  # contains "10.0.0.0/8". The validation uses !contains(), so a single bad
  # element poisons the whole list.
  command = plan

  variables {
    operator_cidrs = ["203.0.113.0/24", "10.0.0.0/8"]
  }

  expect_failures = [var.operator_cidrs]
}

run "rejects_empty_list" {
  # An empty list satisfies the type constraint but fails the length > 0
  # condition, ensuring a workspace cannot accidentally allow no traffic at all.
  command = plan

  variables {
    operator_cidrs = []
  }

  expect_failures = [var.operator_cidrs]
}

run "rejects_list_with_only_placeholder_among_multiple_copies" {
  # Regression: multiple copies of "10.0.0.0/8" must still be rejected
  # (not just a single occurrence).
  command = plan

  variables {
    operator_cidrs = ["10.0.0.0/8", "10.0.0.0/8"]
  }

  expect_failures = [var.operator_cidrs]
}