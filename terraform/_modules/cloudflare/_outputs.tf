output "tunnel_id" {
  value = cloudflare_zero_trust_tunnel_cloudflared.main.id
}

output "tunnel_token" {
  sensitive = true
  value = data.cloudflare_zero_trust_tunnel_cloudflared_token.main.token
}