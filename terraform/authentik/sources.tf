module "bitwarden_secret_discord" {
  source = "../_modules/bitwarden/secret"

  key             = "discord"
  organization_id = var.bitwarden_organization_id
}

resource "authentik_source_oauth" "discord" {
  consumer_key    = module.bitwarden_secret_discord.values["DISCORD_CLIENT_ID"]
  consumer_secret = module.bitwarden_secret_discord.values["DISCORD_CLIENT_SECRET"]
  name            = "Discord"
  provider_type   = "discord"
  slug            = "discord"

  authentication_flow = data.authentik_flow.default-source-authentication.id
  enrollment_flow     = authentik_flow.enrollment.uuid
}