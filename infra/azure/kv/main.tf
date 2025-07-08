resource "azurerm_resource_group" "main" {
  name     = "rg-devopsfrontier-app"
  location = "westeurope"
}

resource "azurerm_key_vault" "main" {
  name                       = "kv-devopsfrontier-app"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  sku_name                   = "standard"
  tenant_id                  = var.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  enable_rbac_authorization  = true
}

// managed identity
resource "azurerm_user_assigned_identity" "main" {
  name                = "mi-devopsfrontier-app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

data "azuread_user" "main" {
  user_principal_name = "info_devopsfrontier.com#EXT#@infodevopsfrontier.onmicrosoft.com"
}

resource "azuread_application" "main" {
  display_name = "devopsfrontier-app"
  owners       = [data.azuread_user.main.id]
}

resource "azuread_application_password" "main" {
  application_id = azuread_application.main.id
  display_name   = "default"
}

// Service principal for the app registration
resource "azuread_service_principal" "main" {
  client_id = azuread_application.main.client_id
  owners    = [data.azuread_user.main.id]
}

// Data source to get the current Terraform service principal
data "azuread_client_config" "current" {}

// Role assignment to grant Key Vault Secrets Officer access to the Terraform service principal
resource "azurerm_role_assignment" "terraform_kv_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azuread_client_config.current.object_id
}

// Role assignment to grant Key Vault Secrets User access to the app registration
resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.main.object_id
}

// Test secret for the application
resource "azurerm_key_vault_secret" "test_secret" {
  name         = "test-secret"
  value        = "Hello from Azure Key Vault!"
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_role_assignment.terraform_kv_secrets_officer]
}
