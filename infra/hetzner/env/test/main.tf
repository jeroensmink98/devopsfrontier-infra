# Learn our public IPv4 address
data "http" "current_ip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  datacenter  = "fsn1-dc14"
  image       = "debian-12"
  server_type = "cx22"

  # Define trusted IPs for SSH access
  trusted_ips = [
    # Add your static/trusted IPs here
    # "203.0.113.1", # Example static IP
    # "198.51.100.1", # Another example
    "81.206.181.82/32" # Home IP

  ]

  # Combine trusted IPs with current IP
  allowed_ssh_ips = concat(local.trusted_ips, ["${chomp(data.http.current_ip.response_body)}/32"])
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
  source                = "../../modules/dns"
  cloudflare_api_token  = var.cloudflare_api_token
  cloudflare_zone_id    = var.cloudflare_zone_id
  server_ip             = module.compute.server_ip
  additional_subdomains = ["app"]
}

# Generate Ansible inventory file
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    server_name     = module.compute.server_name
    server_ip       = module.compute.server_ip
    server_hostname = module.dns.server_hostname
  })
  filename        = "${path.module}/ansible/inventory.ini"
  file_permission = "0644"
}
