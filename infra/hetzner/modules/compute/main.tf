resource "hcloud_primary_ip" "main" {
  name          = "main"
  datacenter    = var.datacenter
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
}

data "hcloud_image" "main" {
  name = var.image
}

resource "hcloud_network" "main" {
  name     = "main"
  ip_range = "10.0.0.0/8"
}
resource "hcloud_network_subnet" "main" {
  network_id   = hcloud_network.main.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_floating_ip" "main" {
  type      = "ipv4"
  server_id = hcloud_server.main.id
}

resource "hcloud_server_network" "main" {
  server_id  = hcloud_server.main.id
  network_id = hcloud_network.main.id
  ip         = "10.0.1.5"
}

resource "hcloud_ssh_key" "main" {
  name = "main"

  public_key = file(var.ssh_key)
}

resource "hcloud_server" "main" {
  name        = "main"
  image       = data.hcloud_image.main.id
  server_type = var.server_type
  datacenter  = var.datacenter
  labels      = var.labels
  ssh_keys    = [hcloud_ssh_key.main.id]

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.main.id
    ipv6_enabled = false
  }
}

resource "hcloud_firewall" "main" {
  name = "main"

  rule {
    direction  = "in"
    port       = "22"
    protocol   = "tcp"
    source_ips = ["${var.current_ip}/32"]
  }

  rule {
    direction  = "in"
    port       = "80"
    protocol   = "tcp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    port       = "443"
    protocol   = "tcp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # Allow all outbound traffic
  rule {
    direction       = "out"
    port            = "any"
    protocol        = "tcp"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction       = "out"
    port            = "any"
    protocol        = "udp"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction       = "out"
    protocol        = "icmp"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_firewall_attachment" "main" {
  firewall_id = hcloud_firewall.main.id
  server_ids  = [hcloud_server.main.id]
}
