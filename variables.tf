# variables.tf
# ------------------------------------------------------------------------------
# Input variables = the "function arguments" of your Terraform project.
# They let the same code run against different tenants without editing it.
# ------------------------------------------------------------------------------

variable "tenant_id" {
  description = "The Azure AD (Entra ID) tenant ID to manage. Get it with: az account show --query tenantId -o tsv"
  type        = string
  # No `default` on purpose: Terraform will REQUIRE a value, so you can never
  # accidentally run against the wrong (or no) tenant.
}
