resource "authentik_stage_authenticator_validate" "mfa-validation" {
  name                  = "authentication-mfa-validation"
  not_configured_action = "skip"

  device_classes = [
    "static",
    "totp"
  ]
}

resource "authentik_stage_identification" "authentication" {
  name = "authentication-identification"

  case_insensitive_matching = false
  password_stage            = authentik_stage_password.authentication.id
  pretend_user_exists       = true
  show_matched_user         = false
  show_source_labels        = true
  sources = [
    authentik_source_oauth.discord.uuid
  ]
  user_fields = [
    "email",
    "username"
  ]
}

resource "authentik_stage_invitation" "enrollment" {
  name = "enrollment-invitation"

  continue_flow_without_invitation = false
}

resource "authentik_stage_password" "authentication" {
  backends = [
    "authentik.core.auth.InbuiltBackend"
  ]
  name = "authentication-password"

  failed_attempts_before_cancel = 3
}

resource "authentik_stage_prompt" "enrollment" {
  fields = [
    authentik_stage_prompt_field.email.id,
    authentik_stage_prompt_field.name.id,
    authentik_stage_prompt_field.password.id,
    authentik_stage_prompt_field.password-repeat.id,
    authentik_stage_prompt_field.username.id
  ]
  name = "enrollment-prompt"

  validation_policies = [
    authentik_policy_password.complexity.id
  ]
}

resource "authentik_stage_user_login" "authentication" {
  name = "authentication-user-login"
}

resource "authentik_stage_user_login" "enrollment" {
  name = "enrollment-user-login"
}

resource "authentik_stage_user_write" "enrollment" {
  name = "enrollment-user-write"

  create_users_as_inactive = false
  create_users_group       = authentik_group.guest.id
}