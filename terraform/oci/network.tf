resource "oci_core_vcn" "main" {
  compartment_id = local.oci_compartment_id

  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "main"
  dns_label      = "kubernetes"
  is_ipv6enabled = true
}

resource "oci_core_internet_gateway" "main" {
  compartment_id = local.oci_compartment_id
  vcn_id         = oci_core_vcn.main.id

  enabled = true
}

resource "oci_core_route_table" "main" {
  compartment_id = local.oci_compartment_id
  vcn_id         = oci_core_vcn.main.id

  display_name = "kubernetes"

  route_rules {
    network_entity_id = oci_core_internet_gateway.main.id

    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_security_list" "main" {
  compartment_id = local.oci_compartment_id
  vcn_id         = oci_core_vcn.main.id

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

  lifecycle {
    ignore_changes = [
      egress_security_rules,
      ingress_security_rules
    ]
  }
}

resource "oci_core_subnet" "kubernetes" {
  cidr_block     = cidrsubnet(oci_core_vcn.main.cidr_block, 8, 0)
  compartment_id = local.oci_compartment_id
  vcn_id         = oci_core_vcn.main.id

  display_name      = "kubernetes"
  route_table_id    = oci_core_route_table.main.id
  security_list_ids = [oci_core_security_list.main.id]
}

resource "oci_core_network_security_group" "main" {
  compartment_id = local.oci_compartment_id
  vcn_id         = oci_core_vcn.main.id
}

resource "oci_core_network_security_group_security_rule" "main" {
  network_security_group_id = oci_core_network_security_group.main.id
  direction                 = "EGRESS"
  protocol                  = "all"

  destination      = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
  stateless        = false
}