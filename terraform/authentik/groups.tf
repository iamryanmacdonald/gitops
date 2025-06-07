resource "authentik_group" "guest" {
  name = "Authentik - Guest"

  is_superuser = false
}