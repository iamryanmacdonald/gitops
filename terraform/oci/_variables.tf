variable "cluster_name" {
  type = string
}

variable "oci_ccm_version" {
  default = "v1.31.0"
  type    = string
}

variable "oci_compartment_id" {
  type = string
}

variable "oci_region" {
  type = string
}

variable "oci_tenancy_id" {
  type = string
}

variable "talos_ccm_version" {
  default = "v1.9.1"
  type    = string
}

variable "talos_version" {
  type = string
}