terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "2.4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.47.0"
    }
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = var.subscription_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret
  tenant_id       = var.tenant_id
}

provider "azapi" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret
}

provider "azuread" {
  tenant_id     = var.tenant_id
  client_id     = var.arm_client_id
  client_secret = var.arm_client_secret
}
