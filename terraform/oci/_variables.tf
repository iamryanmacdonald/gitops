variable "bitwarden_access_token" {
  type = string
}

variable "bitwarden_organization_id" {
  type = string
}

variable "oci_ccm_version" {
  default = "v1.31.0"
  type    = string
}

variable "talos_ccm_version" {
  default = "v1.9.1"
  type    = string
}

variable "talos_version" {
  default = "v1.10.3"
  type    = string
}