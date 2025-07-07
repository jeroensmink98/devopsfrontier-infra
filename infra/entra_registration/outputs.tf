output "client_id" {
  value     = azuread_application.main.client_id
  sensitive = false
}

output "client_secret" {
  value     = azuread_application_password.main.value
  sensitive = true
}
