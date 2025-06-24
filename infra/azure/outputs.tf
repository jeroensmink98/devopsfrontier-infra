# Mistral Small 2503 Model Outputs
output "mistral_small_endpoint_url" {
  description = "The endpoint URL for the Mistral Small 2503 serverless deployment"
  value       = "https://${azapi_resource.serverless_endpoint.name}.${azapi_resource.serverless_endpoint.location}.inference.ml.azure.com/v1"
  sensitive   = false
}

# Retrieve API keys using azapi_resource_action
resource "azapi_resource_action" "mistral_small_keys" {
  type        = "Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2025-01-01-preview"
  resource_id = azapi_resource.serverless_endpoint.id
  action      = "listKeys"
  method      = "POST"
  depends_on  = [azapi_resource.serverless_endpoint]
}

# Mistral OCR 2503 Model Outputs
output "mistral_ocr_endpoint_url" {
  description = "The endpoint URL for the Mistral OCR 2503 serverless deployment"
  value       = "https://${azapi_resource.ocr_serverless_endpoint.name}.${azapi_resource.ocr_serverless_endpoint.location}.inference.ml.azure.com/v1"
  sensitive   = false
}

resource "azapi_resource_action" "mistral_ocr_keys" {
  type        = "Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2025-01-01-preview"
  resource_id = azapi_resource.ocr_serverless_endpoint.id
  action      = "listKeys"
  method      = "POST"
  depends_on  = [azapi_resource.ocr_serverless_endpoint]
}

output "mistral_ocr_api_key" {
  description = "The primary API key for the Mistral OCR 2503 serverless deployment"
  value       = azapi_resource_action.mistral_ocr_keys
  sensitive   = true
}

output "mistral_ocr_secondary_key" {
  description = "The secondary API key for the Mistral OCR 2503 serverless deployment"
  value       = azapi_resource_action.mistral_ocr_keys
  sensitive   = true
}

# Model Information Outputs
output "mistral_small_model_id" {
  description = "The model ID for the Mistral Small 2503 deployment"
  value       = local.models.mistral-small-2503.model_id
  sensitive   = false
}

output "mistral_ocr_model_id" {
  description = "The model ID for the Mistral OCR 2503 deployment"
  value       = local.models.mistral-ocr-2503.model_id
  sensitive   = false
}

# Deployment Names
output "mistral_small_deployment_name" {
  description = "The deployment name for the Mistral Small 2503 serverless endpoint"
  value       = azapi_resource.serverless_endpoint.name
  sensitive   = false
}

output "mistral_ocr_deployment_name" {
  description = "The deployment name for the Mistral OCR 2503 serverless endpoint"
  value       = azapi_resource.ocr_serverless_endpoint.name
  sensitive   = false
}
