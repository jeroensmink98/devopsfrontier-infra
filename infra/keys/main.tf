#---------------------------------------------------------------
# Generates SSH2 key Pair 
#---------------------------------------------------------------
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#-----------------------------------
# Random Resources
#-----------------------------------
resource "random_password" "passwd" {
  length           = 12
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  special          = true
  override_special = "@#!="
  min_special      = 1
}

#-----------------------------------
# Save keys to local files
#-----------------------------------
resource "local_file" "ssh_private_key" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = "${path.module}/generated_keys/id_rsa"
  file_permission = "0600"
}

resource "local_file" "ssh_public_key" {
  content         = tls_private_key.rsa.public_key_openssh
  filename        = "${path.module}/generated_keys/id_rsa.pub"
  file_permission = "0644"
}

resource "local_file" "password_file" {
  content         = random_password.passwd.result
  filename        = "${path.module}/generated_keys/password.txt"
  file_permission = "0600"
}

#-----------------------------------
# Generate certificate request
#-----------------------------------
resource "tls_cert_request" "cert_request" {
  private_key_pem = tls_private_key.rsa.private_key_pem

  subject {
    common_name   = "devopsfrontier.com"
    organization  = "DevOps Frontier"
    email_address = "info@devopsfrontier.com"
    country       = "NL"
  }
}

resource "local_file" "cert_request_file" {
  content         = tls_cert_request.cert_request.cert_request_pem
  filename        = "${path.module}/generated_keys/cert_request.pem"
  file_permission = "0600"
}


resource "time_static" "update_time" {
  triggers = {
    cert_request = tls_cert_request.cert_request.cert_request_pem
  }
}
