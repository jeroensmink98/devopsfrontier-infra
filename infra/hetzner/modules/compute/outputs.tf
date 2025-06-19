output "server_id" {
  value = hcloud_server.main.id
}

output "server_name" {
  value = hcloud_server.main.name
}

output "server_ip" {
  value = hcloud_server.main.ipv4_address
}
