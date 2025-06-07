module "bitwarden_secret_grafana" {
  source = "../_modules/bitwarden/secret"

  key             = "grafana"
  organization_id = var.bitwarden_organization_id
}

resource "authentik_provider_oauth2" "grafana" {
  authorization_flow = data.authentik_flow.default-provider-authorization-implicit-consent.id
  client_id          = module.bitwarden_secret_grafana.values["GRAFANA_CLIENT_ID"]
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
  name               = "Grafana"

  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://grafana.${var.domains["main"]}/login/generic_oauth"
    }
  ]
  client_secret     = module.bitwarden_secret_grafana.values["GRAFANA_CLIENT_SECRET"]
  property_mappings = data.authentik_property_mapping_provider_scope.oauth2.ids
}

resource "authentik_application" "grafana" {
  name = "Grafana"
  slug = "grafana"

  group             = "Observability"
  meta_description  = "Grafana enables you to query, visualize, alert on, and explore your metrics, logs, and traces wherever they are stored."
  meta_icon         = "https://raw.githubusercontent.com/homarr-labs/dashboard-icons/main/png/grafana.png"
  meta_launch_url   = "https://grafana.${var.domains["main"]}"
  meta_publisher    = "Grafana Labs"
  protocol_provider = authentik_provider_oauth2.grafana.id
}

resource "authentik_group" "grafana_admin" {
  name = "Grafana - Admin"
}

resource "authentik_group" "grafana_editor" {
  name = "Grafana - Editor"
}

resource "authentik_group" "grafana_viewer" {
  name = "Grafana - Viewer"
}