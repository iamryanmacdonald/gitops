resource "spot_cloudspace" "homelab" {
  region = "aus-syd-1"

  cloudspace_name    = "homelab"
  cni                = "cilium"
  hacontrol_plane    = false
  kubernetes_version = "1.31.1"
  wait_until_ready   = true
}

resource "spot_spotnodepool" "main" {
  bid_price       = 0.01
  cloudspace_name = spot_cloudspace.homelab.cloudspace_name
  server_class    = "gp.vs1.large-syd"

  autoscaling = {
    min_nodes = 2
    max_nodes = 4
  }
}

data "spot_kubeconfig" "homelab" {
  cloudspace_name = spot_cloudspace.homelab.cloudspace_name
}

resource "local_sensitive_file" "kubeconfig" {
  filename = "${path.module}/../../kubeconfig"

  content = data.spot_kubeconfig.homelab.raw
}