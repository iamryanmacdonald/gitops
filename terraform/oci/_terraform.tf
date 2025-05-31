terraform {
  backend "s3" {}
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "7.2.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0-alpha.0"
    }
  }
}