# Learn our public IPv4 address
data "http" "current_ip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  datacenter  = "fsn1-dc14"
  image       = "debian-12"
  server_type = "cx22"
}

module "compute" {
  source      = "../../modules/compute"
  datacenter  = local.datacenter
  image       = local.image
  server_type = local.server_type
  ssh_key     = "~/.ssh/id_rsa.pub"
  current_ip  = chomp(data.http.current_ip.response_body)
  labels = {
    "OS" : local.image
  }
}
