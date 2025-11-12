terraform {
  backend "s3" {
    bucket                      = "terraform"
    key                         = "oci/terraform.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
  required_providers {
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "0.16.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "7.25.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
  }
}