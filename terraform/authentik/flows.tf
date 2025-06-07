resource "authentik_flow" "authentication" {
  designation = "authentication"
  name        = "authentication-flow"
  slug        = "authentication-flow"
  title       = "Welcome!"

  policy_engine_mode = "all"
}

resource "authentik_flow_stage_binding" "authentication-00" {
  order  = 0
  stage  = authentik_stage_identification.authentication.id
  target = authentik_flow.authentication.uuid
}

resource "authentik_flow_stage_binding" "authentication-10" {
  order  = 10
  stage  = authentik_stage_authenticator_validate.mfa-validation.id
  target = authentik_flow.authentication.uuid
}

resource "authentik_flow_stage_binding" "authentication-100" {
  order  = 100
  stage  = authentik_stage_user_login.authentication.id
  target = authentik_flow.authentication.uuid
}

resource "authentik_flow" "enrollment" {
  designation = "enrollment"
  name        = "enrollment-flow"
  slug        = "enrollment-flow"
  title       = "Enrollment"

  compatibility_mode = true
}

resource "authentik_flow_stage_binding" "enrollment-00" {
  order  = 0
  stage  = authentik_stage_invitation.enrollment.id
  target = authentik_flow.enrollment.uuid
}

resource "authentik_flow_stage_binding" "enrollment-10" {
  order  = 10
  stage  = authentik_stage_prompt.enrollment.id
  target = authentik_flow.enrollment.uuid
}

resource "authentik_flow_stage_binding" "enrollment-100" {
  order  = 100
  stage  = authentik_stage_user_write.enrollment.id
  target = authentik_flow.enrollment.uuid
}

resource "authentik_flow_stage_binding" "enrollment-101" {
  order  = 101
  stage  = authentik_stage_user_login.enrollment.id
  target = authentik_flow.enrollment.uuid
}