resource "authentik_stage_prompt_field" "email" {
  field_key = "email"
  label     = "Email"
  name      = "email"
  type      = "email"

  order = 102
}

resource "authentik_stage_prompt_field" "name" {
  field_key = "name"
  label     = "Name"
  name      = "name"
  type      = "text"

  order = 101
}

resource "authentik_stage_prompt_field" "password" {
  field_key = "password"
  label     = "Password"
  name      = "password"
  type      = "password"

  order = 200
}

resource "authentik_stage_prompt_field" "password-repeat" {
  field_key = "password-repeat"
  label     = "Password (Repeat)"
  name      = "password-repeat"
  type      = "password"

  order = 201
}

resource "authentik_stage_prompt_field" "username" {
  field_key = "username"
  label     = "Username"
  name      = "username"
  type      = "text"

  order = 100
}