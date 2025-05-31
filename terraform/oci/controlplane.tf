data "oci_identity_availability_domains" "main" {
  compartment_id = var.oci_compartment_id
}

resource "oci_core_instance" "controlplane" {
  availability_domain = data.oci_identity_availability_domains.main.availability_domains[0].name
  compartment_id      = var.oci_compartment_id
  shape               = "VM.Standard.A1.Flex"

  display_name = "controlplane-01"
  metadata = {
    user_data = base64encode(data.talos_machine_configuration.controlplane.machine_configuration)
  }

  agent_config {
    are_all_plugins_disabled = true
    is_management_disabled   = true
    is_monitoring_disabled   = true
  }

  create_vnic_details {
    assign_public_ip = true
    private_ip       = "10.0.0.10"
    subnet_id        = oci_core_subnet.kubernetes.id
  }

  launch_options {
    boot_volume_type        = "PARAVIRTUALIZED"
    firmware                = "UEFI_64"
    network_type            = "PARAVIRTUALIZED"
    remote_data_volume_type = "PARAVIRTUALIZED"
  }

  lifecycle {
    ignore_changes = [metadata]
  }

  shape_config {
    memory_in_gbs = 24
    ocpus         = 4
  }

  source_details {
    source_id   = oci_core_image.talos-arm64.id
    source_type = "image"

    boot_volume_size_in_gbs = 200
  }
}

resource "oci_network_load_balancer_backend" "talos" {
  backend_set_name         = oci_network_load_balancer_backend_set.talos.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane-lb.id
  port                     = 50000

  name      = "talos-01"
  target_id = oci_core_instance.controlplane.id
}

resource "oci_network_load_balancer_backend" "controlplane" {
  backend_set_name         = oci_network_load_balancer_backend_set.controlplane.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane-lb.id
  port                     = 6443

  name      = "controlplane-01"
  target_id = oci_core_instance.controlplane.id
}

resource "talos_machine_configuration_apply" "controlplane" {
  depends_on = [oci_core_instance.controlplane]

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = oci_core_instance.controlplane.private_ip

  endpoint = local.endpoints[0]
}

resource "talos_machine_bootstrap" "controlplane" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = oci_core_instance.controlplane.private_ip

  endpoint = local.endpoints[0]
}