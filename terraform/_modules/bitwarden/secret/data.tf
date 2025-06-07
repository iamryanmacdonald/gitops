data "bitwarden_secret" "this" {
  key             = var.key
  organization_id = var.organization_id
}