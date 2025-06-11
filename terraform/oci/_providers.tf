provider "bitwarden" {
  access_token = var.bitwarden_access_token

  experimental {
    embedded_client = true
  }
}

provider "oci" {
  fingerprint  = module.bitwarden_secret_oci.values["OCI_FINGERPRINT"]
  private_key  = data.bitwarden_secret.oci_private_key.value
  region       = module.bitwarden_secret_oci.values["OCI_REGION"]
  tenancy_ocid = module.bitwarden_secret_oci.values["OCI_TENANCY_OCID"]
  user_ocid    = module.bitwarden_secret_oci.values["OCI_USER_OCID"]
}

provider "talos" {}

data "bitwarden_secret" "oci_private_key" {
  key             = "oci-private-key"
  organization_id = var.bitwarden_organization_id
}

module "bitwarden_secret_oci" {
  source = "../_modules/bitwarden/secret"

  key             = "oci"
  organization_id = var.bitwarden_organization_id
}