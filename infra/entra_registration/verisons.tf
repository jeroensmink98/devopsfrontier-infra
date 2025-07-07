# Tell terraform to use the provider and select a version.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.35.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.4.0"
    }
  }

  backend "s3" {
    bucket       = "terraformstate234223214"
    key          = "entra_registration.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
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

# provider "azapi" {
#   subscription_id = var.subscription_id
#   tenant_id       = var.tenant_id
#   client_id       = var.arm_client_id
#   client_secret   = var.arm_client_secret
# }

provider "azuread" {
  tenant_id     = var.tenant_id
  client_id     = var.arm_client_id
  client_secret = var.arm_client_secret
}
