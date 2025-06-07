terraform {
  backend "s3" {}
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2025.4.0"
    }
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "0.13.6"
    }
  }
}