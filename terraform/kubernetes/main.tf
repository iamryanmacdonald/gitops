data "kubernetes_namespace" "network" {
  metadata {
    name = "network"
  }
}

resource "kubernetes_secret" "cloudflared-token" {
  metadata {
    name = "cloudflared-token"
    namespace = "network"
  }

  data = {
    TUNNEL_TOKEN = var.cloudflare_tunnel_token
  }
  type = "Opaque"

  depends_on = [data.kubernetes_namespace.network]
}