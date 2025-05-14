terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    spot = {
      source  = "rackerlabs/spot"
      version = "0.1.4"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "kubernetes" {
  config_path = "${path.module}/../kubeconfig"
}

provider "spot" {
  token = var.rackerlabs_spot_token
}