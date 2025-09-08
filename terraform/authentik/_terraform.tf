terraform {
  backend "s3" {
    bucket                      = "terraform"
    key                         = "authentik/terraform.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2025.8.1"
    }
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "0.16.0"
    }
  }
}