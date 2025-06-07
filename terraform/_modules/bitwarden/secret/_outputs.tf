output "values" {
  description = "A map of all environment variables that are in the secret"
  sensitive   = true
  value       = { for tuple in regexall("(.*?): (.*)", data.bitwarden_secret.this.value) : tuple[0] => tuple[1] }
}