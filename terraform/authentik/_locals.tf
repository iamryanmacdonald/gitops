module "bitwarden_secret_variables" {
  source = "../_modules/bitwarden/secret"

  key             = "terraform-authentik"
  organization_id = var.bitwarden_organization_id
}

locals {
  authentik_url = module.bitwarden_secret_variables.values["authentik_url"]
  domains = {
    main = module.bitwarden_secret_variables.values["domains_main"]
  }
}