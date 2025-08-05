variable "hcloud_token" {
  type        = string
  description = "The token for the Hetzner Cloud account"
  sensitive   = true
}

variable "cloudflare_api_token" {
  type        = string
  description = "The API token for the Cloudflare account"
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The ID of the Cloudflare zone to manage"
}
