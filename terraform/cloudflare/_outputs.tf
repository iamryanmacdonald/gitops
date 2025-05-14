output "tunnel_id" {
  value = cloudflare_zero_trust_tunnel_cloudflared.homelab.id
}

output "tunnel_token" {
  # sensitive = true
  value = data.cloudflare_zero_trust_tunnel_cloudflared_token.homelab.token
}