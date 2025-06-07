provider "authentik" {
  token = module.bitwarden_secret_authentik.values["AUTHENTIK_TOKEN"]
  url   = var.authentik_url
}

provider "bitwarden" {
  access_token = var.bitwarden_access_token

  experimental {
    embedded_client = true
  }
}

module "bitwarden_secret_authentik" {
  source = "../_modules/bitwarden/secret"

  key             = "authentik"
  organization_id = var.bitwarden_organization_id
}