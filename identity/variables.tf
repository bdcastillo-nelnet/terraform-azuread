variable "tenant_id" {
  description = "The Azure AD (Entra ID) tenant ID to manage. Get it with: az account show --query tenantId -o tsv"
  type        = string
}
