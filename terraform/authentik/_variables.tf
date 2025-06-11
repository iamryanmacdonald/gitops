variable "bitwarden_access_token" {
  type = string
}

variable "bitwarden_organization_id" {
  type = string
}

variable "cicd" {
  default = false
  type    = bool
}