resource "oci_identity_dynamic_group" "ccm" {
  compartment_id = var.oci_tenancy_id
  description    = "Instance access for CCM"
  matching_rule  = "ALL {instance.compartment.id = '${var.oci_compartment_id}'}"
  name           = "oci-ccm"
}

data "oci_identity_compartment" "this" {
  id = var.oci_compartment_id
}

resource "oci_identity_policy" "ccm" {
  compartment_id = var.oci_tenancy_id
  description    = "Instance access for CCM"
  name           = "oci-ccm"
  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.ccm.name} to manage load-balancers in compartment ${data.oci_identity_compartment.this.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ccm.name} to read instance-family in compartment ${data.oci_identity_compartment.this.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ccm.name} to use virtual-network-family in compartment ${data.oci_identity_compartment.this.name}"
  ]
}