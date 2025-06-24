# locals {
#   custom_domains = [
#     "craaper.com",
#     "www.craaper.com",
#   ]
# }

# # Get the domain verification ID from the web app
# data "azurerm_linux_web_app" "web_app_data" {
#   name                = azurerm_linux_web_app.web_app.name
#   resource_group_name = azurerm_linux_web_app.web_app.resource_group_name
# }

# resource "azurerm_app_service_custom_hostname_binding" "main" {
#   for_each            = toset(local.custom_domains)
#   hostname            = each.value
#   app_service_name    = azurerm_linux_web_app.web_app.name
#   resource_group_name = azurerm_linux_web_app.web_app.resource_group_name

#   lifecycle {
#     ignore_changes = [ssl_state, thumbprint]
#   }
# }

# # Create App Service Managed Certificate for each custom domain
# resource "azurerm_app_service_managed_certificate" "main" {
#   for_each                   = toset(local.custom_domains)
#   custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.main[each.value].id

#   depends_on = [azurerm_app_service_custom_hostname_binding.main]
# }

# # Create SSL binding for each custom domain
# resource "azurerm_app_service_certificate_binding" "main" {
#   for_each            = toset(local.custom_domains)
#   hostname_binding_id = azurerm_app_service_custom_hostname_binding.main[each.value].id
#   certificate_id      = azurerm_app_service_managed_certificate.main[each.value].id
#   ssl_state           = "SniEnabled"

#   depends_on = [azurerm_app_service_managed_certificate.main]
# }

# # Output the domain verification ID and required DNS records
# output "domain_verification_id" {
#   description = "The domain verification ID for custom domain verification"
#   value       = data.azurerm_linux_web_app.web_app_data.custom_domain_verification_id
#   sensitive   = true
# }

# output "required_dns_records" {
#   description = "DNS records required for domain verification"
#   sensitive   = true
#   value = {
#     for domain in local.custom_domains : domain => {
#       txt_record = {
#         name  = "asuid.${domain}"
#         value = data.azurerm_linux_web_app.web_app_data.custom_domain_verification_id
#       }
#       cname_record = {
#         name  = domain
#         value = azurerm_linux_web_app.web_app.default_hostname
#       }
#     }
#   }
# }

