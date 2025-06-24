resource "random_string" "serverless_endpoint_name" {
  length  = 4
  special = false
}

locals {
  models = {
    mistral-small-2503 = {
      model_id                      = "azureml://registries/azureml-mistral/models/mistral-small-2503"
      serverless_endpoint_name      = "mistral-small-2503-serverless-${random_string.serverless_endpoint_name.result}"
      marketplace_subscription_name = "mistral-small-2503-sub-${random_string.serverless_endpoint_name.result}"
    }
    mistral-ocr-2503 = {
      model_id                      = "azureml://registries/azureml-mistral/models/mistral-ocr-2503"
      serverless_endpoint_name      = "mistral-ocr-2503-serverless-${random_string.serverless_endpoint_name.result}"
      marketplace_subscription_name = "mistral-ocr-2503-sub-${random_string.serverless_endpoint_name.result}"
    }
  }
}


resource "azapi_resource" "model_sub" {
  type      = "Microsoft.MachineLearningServices/workspaces/marketplaceSubscriptions@2024-04-01-preview"
  name      = local.models.mistral-small-2503.marketplace_subscription_name
  parent_id = azurerm_ai_foundry_project.main.id
  body = {
    properties = {
      modelId = local.models.mistral-small-2503.model_id
    }
  }
}

resource "azapi_resource" "serverless_endpoint" {
  type      = "Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2025-01-01-preview"
  name      = local.models.mistral-small-2503.serverless_endpoint_name
  parent_id = azurerm_ai_foundry_project.main.id
  location  = azurerm_ai_foundry_project.main.location

  body = {
    kind = "Serverless"
    properties = {
      authMode = "Key"
      contentSafety = {
        contentSafetyStatus = "Enabled"
        contentSafetyLevel  = "Blocking"
      }
      modelSettings = { modelId = local.models.mistral-small-2503.model_id }
    }
    sku = {
      name = "Consumption"
      tier = "Free"
    }
  }
  depends_on = [azapi_resource.model_sub]
}

resource "azapi_resource" "ocr_model_sub" {
  type      = "Microsoft.MachineLearningServices/workspaces/marketplaceSubscriptions@2024-04-01-preview"
  name      = local.models.mistral-ocr-2503.marketplace_subscription_name
  parent_id = azurerm_ai_foundry_project.main.id
  body = {
    properties = {
      modelId = local.models.mistral-ocr-2503.model_id
    }
  }
}

resource "azapi_resource" "ocr_serverless_endpoint" {
  type      = "Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2025-01-01-preview"
  name      = local.models.mistral-ocr-2503.serverless_endpoint_name
  parent_id = azurerm_ai_foundry_project.main.id
  location  = azurerm_ai_foundry_project.main.location

  body = {
    kind = "Serverless"
    properties = {
      authMode = "Key"
      contentSafety = {
        contentSafetyStatus = "Enabled"
        contentSafetyLevel  = "Blocking"
      }
      modelSettings = { modelId = local.models.mistral-ocr-2503.model_id }
    }
    sku = {
      name = "Consumption"
      tier = "Free"
    }
  }
  depends_on = [azapi_resource.ocr_model_sub]
}
