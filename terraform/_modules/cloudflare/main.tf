resource "cloudflare_zero_trust_tunnel_cloudflared" "main" {
  account_id = var.account_id
  name       = var.name

  config_src = "local"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "main" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.main.id
}