module "cloudflare" {
  source = "./cloudflare"

  account_id = var.cloudflare_account_id
}

module "kubernetes" {
  source = "./kubernetes"

  cloudflare_tunnel_token = module.cloudflare.tunnel_token

  depends_on = [module.spot]
}

module "spot" {
  source = "./spot"
}