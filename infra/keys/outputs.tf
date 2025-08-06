output "ssh_private_key" {
  value     = tls_private_key.rsa.private_key_pem
  sensitive = true
}

output "ssh_public_key" {
  value     = tls_private_key.rsa.public_key_openssh
  sensitive = true
}

output "password" {
  value     = random_password.passwd.result
  sensitive = true
}

output "cert_request" {
  value     = tls_cert_request.cert_request.cert_request_pem
  sensitive = true
}

output "update_time" {
  value       = time_static.update_time.id
  description = "The time the certificate request was updated"
  sensitive   = false
}
