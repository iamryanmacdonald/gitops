resource "authentik_policy_password" "complexity" {
  error_message = "Minimum password length: 10. Must contain at least 1 of each of the following: uppercase, lowercase, digit"
  name          = "password-complexity"

  amount_digits    = 1
  amount_lowercase = 1
  amount_uppercase = 1
  length_min       = 10
}