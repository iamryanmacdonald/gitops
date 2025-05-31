resource "oci_core_vcn" "main" {
  compartment_id = var.oci_compartment_id

  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "main"
  dns_label      = "kubernetes"
  is_ipv6enabled = true
}

resource "oci_core_internet_gateway" "main" {
  compartment_id = var.oci_compartment_id
  vcn_id         = oci_core_vcn.main.id

  enabled = true
}

resource "oci_core_route_table" "main" {
  compartment_id = var.oci_compartment_id
  vcn_id         = oci_core_vcn.main.id

  display_name = "kubernetes"

  route_rules {
    network_entity_id = oci_core_internet_gateway.main.id

    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_subnet" "kubernetes" {
  cidr_block     = cidrsubnet(oci_core_vcn.main.cidr_block, 8, 0)
  compartment_id = var.oci_compartment_id
  vcn_id         = oci_core_vcn.main.id

  display_name   = "kubernetes"
  route_table_id = oci_core_route_table.main.id
}

resource "oci_core_default_security_list" "main" {
  compartment_id             = var.oci_compartment_id
  manage_default_resource_id = oci_core_vcn.main.default_security_list_id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"

    stateless = false
  }

  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"

    stateless = false
  }
}