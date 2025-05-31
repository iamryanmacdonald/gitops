variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "name" {
  default     = "home"
  description = "Name for the cloudflared tunnel"
  type        = string
}