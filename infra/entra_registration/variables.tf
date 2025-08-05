variable "subscription_id" {
  type        = string
  description = "The subscription ID for the Azure subscription"
}

variable "tenant_id" {
  type        = string
  description = "The tenant ID for the Azure subscription"
}

variable "arm_client_id" {
  type        = string
  description = "The client ID for the Azure Managed Identity"
}

variable "arm_client_secret" {
  type        = string
  description = "The client secret for the Azure Managed Identity"
}

variable "environment" {
  type        = string
  description = "The environment for the Azure subscription"
}


