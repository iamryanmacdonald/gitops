resource "oci_network_load_balancer_network_load_balancer" "controlplane-lb" {
  compartment_id = local.oci_compartment_id
  display_name   = "controlplane-lb"
  subnet_id      = oci_core_subnet.kubernetes.id

  is_preserve_source_destination = false
  is_private                     = false
}

resource "oci_network_load_balancer_backend_set" "talos" {
  health_checker {
    protocol = "TCP"

    interval_in_millis = 10000
    port               = 50000
  }
  name                     = "talos"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane-lb.id
  policy                   = "TWO_TUPLE"

  is_preserve_source = false
}

resource "oci_network_load_balancer_listener" "talos" {
  default_backend_set_name = oci_network_load_balancer_backend_set.talos.name
  name                     = "talos"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane-lb.id
  port                     = 50000
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_backend_set" "controlplane" {
  health_checker {
    protocol = "HTTPS"

    interval_in_millis = 10000
    port               = 6443
    return_code        = 401
    url_path           = "/readyz"
  }
  name                     = "controlplane"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane-lb.id
  policy                   = "TWO_TUPLE"

  is_preserve_source = false
}

resource "oci_network_load_balancer_listener" "controlplane" {
  default_backend_set_name = oci_network_load_balancer_backend_set.controlplane.name
  name                     = "controlplane"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane-lb.id
  port                     = 6443
  protocol                 = "TCP"
}