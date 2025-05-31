locals {
  endpoints = [for ipa in oci_network_load_balancer_network_load_balancer.controlplane-lb.ip_addresses : ipa.ip_address if ipa.is_public]
  nodes     = [oci_core_instance.controlplane.private_ip]
}

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_client_configuration" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  cluster_name         = var.cluster_name

  endpoints = local.endpoints
  nodes     = local.nodes
}

data "talos_machine_configuration" "controlplane" {
  cluster_endpoint = "https://${local.endpoints[0]}:6443"
  cluster_name     = var.cluster_name
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  machine_type     = "controlplane"

  config_patches = [templatefile("${path.module}/../../talos/controlplane.yaml.tftpl", {
    domain   = var.domain
    hostname = "controlplane-01"
    lb_ip    = local.endpoints[0]
  })]
  talos_version = var.talos_version
}

resource "local_file" "controlplane-01" {
  content  = data.talos_machine_configuration.controlplane.machine_configuration
  filename = "${path.module}/../../talos/controlplane-01.yaml"
}

resource "local_file" "talconfig" {
  content  = data.talos_client_configuration.this.talos_config
  filename = "${path.module}/../../talos/talconfig"
}

data "talos_cluster_health" "this" {
  depends_on = [
    talos_machine_configuration_apply.controlplane,
    talos_machine_bootstrap.controlplane
  ]

  client_configuration = talos_machine_secrets.this.client_configuration
  control_plane_nodes  = local.nodes
  endpoints            = local.endpoints
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.nodes[0]

  endpoint = local.endpoints[0]
}

resource "local_file" "kubeconfig" {
  content  = talos_cluster_kubeconfig.this.kubeconfig_raw
  filename = "${path.module}/../../talos/kubeconfig"
}