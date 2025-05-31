module "cloudflare" {
  source = "./_modules/cloudflare"

  account_id = var.cloudflare_account_id
}

module "kubernetes" {
  source = "./_modules/kubernetes"

  cloudflare_tunnel_token = module.cloudflare.tunnel_token
}