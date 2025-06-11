module "bitwarden_secret_variables" {
  source = "../_modules/bitwarden/secret"

  key             = "terraform-oci"
  organization_id = var.bitwarden_organization_id
}

locals {
  cluster_name       = module.bitwarden_secret_variables.values["cluster_name"]
  oci_compartment_id = module.bitwarden_secret_variables.values["oci_compartment_id"]
  oci_region         = module.bitwarden_secret_variables.values["oci_region"]
  oci_tenancy_id     = module.bitwarden_secret_variables.values["oci_tenancy_id"]
}