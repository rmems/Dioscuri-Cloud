terraform {
  required_version = ">= 1.3.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.0.0"
    }
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
  region       = var.region
}

# ─────────────────────────────────────────────────────────────
# Networking
# ─────────────────────────────────────────────────────────────

resource "oci_core_vcn" "hermes_rag" {
  compartment_id = var.compartment_ocid
  display_name   = "hermes-rag-vcn"
  cidr_block     = "10.0.0.0/16"
  dns_label      = "hermesrag"
}

resource "oci_core_subnet" "hermes_rag" {
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.hermes_rag.id
  display_name        = "hermes-rag-subnet"
  cidr_block          = "10.0.1.0/24"
  availability_domain = var.availability_domain
  dns_label           = "hermesrag"
  security_list_ids   = [oci_core_security_list.hermes_rag.id]
}

resource "oci_core_security_list" "hermes_rag" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.hermes_rag.id
  display_name   = "hermes-rag-sl"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    description = "Allow all outbound"
  }

  ingress_security_rules {
    source      = "0.0.0.0/0"
    protocol    = "6"
    description = "SSH"
    tcp_options {
      max = 22
      min = 22
    }
  }

  ingress_security_rules {
    source      = "0.0.0.0/0"
    protocol    = "6"
    description = "Qdrant"
    tcp_options {
      max = 6333
      min = 6333
    }
  }

  ingress_security_rules {
    source      = "0.0.0.0/0"
    protocol    = "6"
    description = "MCP Server"
    tcp_options {
      max = 8000
      min = 8000
    }
  }
}

# ─────────────────────────────────────────────────────────────
# Compute Instance (Always Free Ampere)
# ─────────────────────────────────────────────────────────────

resource "oci_core_instance" "hermes_rag" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = "hermes-rag"
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = 4
    memory_in_gbs = 24
  }

  source_details {
    source_type = "image"
    source_id   = var.ubuntu_image_id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.hermes_rag.id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  freeform_tags = {
    project = "hermes-rag"
    env     = "dev"
  }
}

# ─────────────────────────────────────────────────────────────
# Existing modules (kept for now)
# ─────────────────────────────────────────────────────────────

module "artifacts" {
  source   = "../../modules/artifact_bucket"
  name     = var.artifact_bucket_name
  location = var.region
  labels   = { env = "dev" }
}

module "artifact_sa" {
  source      = "../../modules/service_account"
  name        = var.service_account_name
  description = "Artifact access principal (Oracle dev)"
  roles       = []
}