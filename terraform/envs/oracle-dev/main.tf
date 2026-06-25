terraform {
  required_version = ">= 1.3.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.0.0"
    }
  }
}

# Prefer var.region; fall back to var.location for backward compatibility with
# HCP workspaces that only set OCI_LOCATION. var.region has no default so the
# coalesce can detect whether it was explicitly set.
locals {
  effective_region = coalesce(var.region, var.location)
  common_tags = {
    owner       = "rmems"
    project     = "hermes-rag"
    env         = "dev"
    linear      = "#48"
    issue       = "#48"
    pr          = "#56"
    teardown_by = "2026-07-10"
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
  region       = local.effective_region
}

# ─────────────────────────────────────────────────────────────
# Networking
# ─────────────────────────────────────────────────────────────

resource "oci_core_vcn" "hermes_rag" {
  compartment_id = var.compartment_ocid
  display_name   = "hermes-rag-vcn"
  cidr_block     = "10.0.0.0/16"
  dns_label      = "hermesrag"
  freeform_tags  = local.common_tags
}

resource "oci_core_subnet" "hermes_rag" {
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.hermes_rag.id
  display_name        = "hermes-rag-subnet"
  cidr_block          = "10.0.1.0/24"
  availability_domain = var.availability_domain
  dns_label           = "hermesrag"
  security_list_ids   = [oci_core_security_list.hermes_rag.id]
  route_table_id      = oci_core_route_table.hermes_rag.id
  freeform_tags       = local.common_tags
}

resource "oci_core_internet_gateway" "hermes_rag" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.hermes_rag.id
  display_name   = "hermes-rag-igw"
  enabled        = true
  freeform_tags  = local.common_tags
}

resource "oci_core_route_table" "hermes_rag" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.hermes_rag.id
  display_name   = "hermes-rag-rt"
  freeform_tags  = local.common_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.hermes_rag.id
    description       = "Default route to Internet Gateway"
  }
}

resource "oci_core_security_list" "hermes_rag" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.hermes_rag.id
  display_name   = "hermes-rag-sl"
  freeform_tags  = local.common_tags

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    description = "Allow all outbound"
  }

  dynamic "ingress_security_rules" {
    for_each = var.operator_cidrs
    content {
      source      = ingress_security_rules.value
      protocol    = "6"
      description = "SSH (operator)"
      tcp_options {
        max = 22
        min = 22
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = var.operator_cidrs
    content {
      source      = ingress_security_rules.value
      protocol    = "6"
      description = "Qdrant (operator)"
      tcp_options {
        max = 6333
        min = 6333
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = var.operator_cidrs
    content {
      source      = ingress_security_rules.value
      protocol    = "6"
      description = "MCP Server (operator)"
      tcp_options {
        max = 8000
        min = 8000
      }
    }
  }
}

# ─────────────────────────────────────────────────────────────
# Compute Instance (Always Free Ampere)
# ─────────────────────────────────────────────────────────────

resource "oci_core_instance" "hermes_rag" {
  compartment_id       = var.compartment_ocid
  availability_domain  = var.availability_domain
  display_name         = "hermes-rag"
  shape                = "VM.Standard.A1.Flex"
  preserve_boot_volume = false

  shape_config {
    ocpus         = 4
    memory_in_gbs = 24
  }

  source_details {
    source_type                     = "image"
    source_id                       = var.ubuntu_image_id
    boot_volume_size_in_gbs         = 100
    is_preserve_boot_volume_enabled = false
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.hermes_rag.id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  freeform_tags = local.common_tags
}

# ─────────────────────────────────────────────────────────────
# Credit Burn Resources (VM.Standard.E5.Flex, expires 2026-06-28)
# ─────────────────────────────────────────────────────────────

locals {
  burn_tags = merge(local.common_tags, {
    purpose     = "credit-burn"
    teardown_by = "2026-06-28"
  })
}

resource "oci_core_vcn" "burn" {
  compartment_id = var.compartment_ocid
  display_name   = "burn-vcn"
  cidr_block     = "10.1.0.0/16"
  dns_label      = "burn"
  freeform_tags  = local.burn_tags
}

resource "oci_core_subnet" "burn" {
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.burn.id
  display_name        = "burn-subnet"
  cidr_block          = "10.1.1.0/24"
  availability_domain = var.availability_domain
  dns_label           = "burn"
  security_list_ids   = [oci_core_security_list.burn.id]
  route_table_id      = oci_core_route_table.burn.id
  freeform_tags       = local.burn_tags
}

resource "oci_core_internet_gateway" "burn" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.burn.id
  display_name   = "burn-igw"
  enabled        = true
  freeform_tags  = local.burn_tags
}

resource "oci_core_route_table" "burn" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.burn.id
  display_name   = "burn-rt"
  freeform_tags  = local.burn_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.burn.id
    description       = "Default route to Internet Gateway"
  }
}

resource "oci_core_security_list" "burn" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.burn.id
  display_name   = "burn-sl"
  freeform_tags  = local.burn_tags

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    description = "Allow all outbound"
  }

  dynamic "ingress_security_rules" {
    for_each = var.operator_cidrs
    content {
      source      = ingress_security_rules.value
      protocol    = "6"
      description = "SSH (operator)"
      tcp_options {
        max = 22
        min = 22
      }
    }
  }
}

resource "oci_core_instance" "burn" {
  compartment_id       = var.compartment_ocid
  availability_domain  = var.availability_domain
  display_name         = "burn-e5-flex"
  shape                = "VM.Standard.E5.Flex"
  preserve_boot_volume = false

  shape_config {
    ocpus         = 64
    memory_in_gbs = 1024
  }

  source_details {
    source_type                     = "image"
    source_id                       = var.ubuntu_image_id
    boot_volume_size_in_gbs         = 500
    is_preserve_boot_volume_enabled = false
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.burn.id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  freeform_tags = local.burn_tags
}

resource "oci_core_volume" "burn" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = "burn-volume-2tb"
  size_in_gbs         = 2048
  vpus_per_gb         = 20
  freeform_tags       = local.burn_tags
}

resource "oci_core_volume_attachment" "burn" {
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.burn.id
  volume_id       = oci_core_volume.burn.id
  display_name    = "burn-volume-attachment"
}

# ─────────────────────────────────────────────────────────────
# Existing modules (kept for now)
# ─────────────────────────────────────────────────────────────

module "artifacts" {
  source   = "../../modules/artifact_bucket"
  name     = var.artifact_bucket_name
  location = local.effective_region
  labels   = { env = "dev" }
}

module "artifact_sa" {
  source      = "../../modules/service_account"
  name        = var.service_account_name
  description = "Artifact access principal (Oracle dev)"
  roles       = []
}