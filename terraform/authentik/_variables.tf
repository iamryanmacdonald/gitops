variable "authentik_url" {
  type = string
}

variable "bitwarden_access_token" {
  type = string
}

variable "bitwarden_organization_id" {
  type = string
}

variable "domains" {
  type = map(string)
}