module "bitwarden_secret_headlamp" {
  source = "../_modules/bitwarden/secret"

  key             = "headlamp"
  organization_id = var.bitwarden_organization_id
}

resource "authentik_provider_oauth2" "headlamp" {
  authorization_flow = data.authentik_flow.default-provider-authorization-implicit-consent.id
  client_id          = module.bitwarden_secret_headlamp.values["HEADLAMP_CLIENT_ID"]
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
  name               = "Headlamp"

  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://headlamp.${local.domains["main"]}/oidc-callback"
    }
  ]
  authentication_flow = authentik_flow.authentication.uuid
  client_secret       = module.bitwarden_secret_headlamp.values["HEADLAMP_CLIENT_SECRET"]
  property_mappings   = data.authentik_property_mapping_provider_scope.oauth2.ids
  signing_key         = data.authentik_certificate_key_pair.generated.id
}

resource "authentik_application" "headlamp" {
  name = "Headlamp"
  slug = "headlamp"

  group             = "Flux System"
  meta_description  = "Headlamp is an easy-to-use and extensible Kubernetes web UI."
  meta_icon         = "https://raw.githubusercontent.com/homarr-labs/dashboard-icons/main/png/headlamp.png"
  meta_launch_url   = "https://headlamp.${local.domains["main"]}"
  meta_publisher    = "Kubernetes"
  protocol_provider = authentik_provider_oauth2.headlamp.id
}