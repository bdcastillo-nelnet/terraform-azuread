variable "tenant_id" {
  description = "Entra tenant ID."
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID that holds the Terraform state storage."
  type        = string
}

variable "github_repository" {
  description = "GitHub repo (owner/name) that Actions run from; used in the OIDC federated credential subject."
  type        = string
}

variable "state_resource_group_name" {
  description = "Resource group holding the Terraform state storage account."
  type        = string
}

variable "state_storage_account_name" {
  description = "Storage account holding the Terraform state, granted to the CI identity."
  type        = string
}
