output "server_hostname" {
  value       = "${cloudflare_dns_record.server.name}.${data.cloudflare_zone.main.name}"
  description = "The fully qualified domain name of the server"
}

output "server_dns_record_id" {
  value       = cloudflare_dns_record.server.id
  description = "The ID of the DNS record created for the server"
}

output "additional_hostnames" {
  value       = { for k, v in cloudflare_dns_record.additional : k => "${v.name}.${data.cloudflare_zone.main.name}" }
  description = "Map of additional subdomains to their fully qualified domain names"
}

output "additional_dns_record_ids" {
  value       = { for k, v in cloudflare_dns_record.additional : k => v.id }
  description = "Map of additional subdomains to their DNS record IDs"
}
