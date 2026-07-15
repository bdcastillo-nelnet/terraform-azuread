variable "tenant_id" {
  description = "Azure AD (Entra ID) tenant ID for the selected environment."
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. sandbox, prod). Used for naming/tagging."
  type        = string
}



