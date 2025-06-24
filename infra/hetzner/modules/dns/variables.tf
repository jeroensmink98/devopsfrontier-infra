variable "cloudflare_api_token" {
  type        = string
  description = "The API token for the Cloudflare account"
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The ID of the Cloudflare zone to manage"
}

variable "server_ip" {
  type        = string
  description = "The IP address of the server to create DNS records for"
}

variable "additional_subdomains" {
  type        = list(string)
  description = "Additional subdomains to create DNS records for (pointing to server_ip)"
  default     = []
}


