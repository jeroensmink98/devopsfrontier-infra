output "server_id" {
  description = "The ID of the created server"
  value       = module.compute.server_id
}

output "server_name" {
  description = "The name of the created server"
  value       = module.compute.server_name
}

output "server_ip" {
  description = "The IPv4 address of the created server"
  value       = module.compute.server_ip
}

output "ssh_command" {
  description = "The ssh command to connect to the created server"
  value       = "ssh -i ~/.ssh/id_rsa root@${module.compute.server_ip}"
}
