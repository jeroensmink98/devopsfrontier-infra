# Learn our public IPv4 address

variable "trusted_ips" {
  description = "List of trusted IPs for SSH access"
  type        = list(string)
}

locals {
  datacenter  = "fsn1-dc14"
  image       = "debian-12"
  server_type = "cx22"

  # Define trusted IPs for SSH access
  trusted_ips = var.trusted_ips
  # Combine trusted IPs with current IP
  allowed_ssh_ips = local.trusted_ips
}

# Compute
module "compute" {
  source          = "../../modules/compute"
  datacenter      = local.datacenter
  image           = local.image
  server_type     = local.server_type
  ssh_key         = "~/.ssh/id_rsa.pub"
  allowed_ssh_ips = local.allowed_ssh_ips
  labels = {
    "OS" : local.image
  }
}

# DNS
module "dns" {
  source               = "../../modules/dns"
  cloudflare_api_token = var.cloudflare_api_token
  cloudflare_zone_id   = var.cloudflare_zone_id
  server_ip            = module.compute.server_ip
  #   additional_subdomains = ["thomas"]
}

