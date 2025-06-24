resource "random_string" "main" {
  length  = 8
  special = false
}


resource "azurerm_resource_group" "main" {
  name     = "rg-${var.environment}-ai-foundry"
  location = "swedencentral"
  tags = {
    environment = var.environment
    project     = "ai-foundry"
  }
}

resource "azurerm_key_vault" "main" {
  name                = "kv-${var.environment}-ai-foundry"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = var.tenant_id

  sku_name                 = "standard"
  purge_protection_enabled = true
}

resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.tenant_id
  object_id    = var.arm_client_id

  key_permissions = [
    "Create",
    "Get",
    "Delete",
    "Purge",
    "GetRotationPolicy",
  ]
}

resource "azurerm_storage_account" "main" {
  name                     = lower("sa${var.environment}ai${random_string.main.result}")
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_ai_services" "main" {
  name                = "ai-services-${var.environment}-ai-foundry"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "S0"
}

resource "azurerm_ai_foundry" "main" {
  name                = "ai-foundry-${var.environment}-ai-foundry"
  location            = azurerm_ai_services.main.location
  resource_group_name = azurerm_resource_group.main.name
  storage_account_id  = azurerm_storage_account.main.id
  key_vault_id        = azurerm_key_vault.main.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_ai_foundry_project" "main" {
  name               = "ai-foundry-project-${var.environment}"
  location           = azurerm_ai_foundry.main.location
  ai_services_hub_id = azurerm_ai_foundry.main.id

  identity {
    type = "SystemAssigned"
  }
}
