resource "cloudflare_zero_trust_tunnel_cloudflared" "homelab" {
  account_id = var.account_id
  name = "homelab"

  config_src = "local"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "homelab" {
  account_id = var.account_id
  tunnel_id = cloudflare_zero_trust_tunnel_cloudflared.homelab.id
}