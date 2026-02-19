variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_account_id" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}

variable "cloudflare_app_id" {
  type = string
}

variable "tunnel_secret" {
  type      = string
  sensitive = true
}
