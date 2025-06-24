data "cloudflare_zone" "main" {
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_dns_record" "server" {
  zone_id = var.cloudflare_zone_id
  name    = "server.${data.cloudflare_zone.main.name}"
  content = var.server_ip
  type    = "A"
  ttl     = 300

  comment = "Hetzner server A record"

  lifecycle {
    ignore_changes = [
      ttl,
    ]
  }
}

# Additional DNS records for subdomains
resource "cloudflare_dns_record" "additional" {
  for_each = toset(var.additional_subdomains)

  zone_id = var.cloudflare_zone_id
  name    = "${each.value}.${data.cloudflare_zone.main.name}"
  content = var.server_ip
  type    = "A"
  ttl     = 1

  comment = "Additional subdomain A record for ${each.value}"

  lifecycle {
    ignore_changes = [
      ttl,
    ]
  }
}

