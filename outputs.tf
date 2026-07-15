# outputs.tf
# ------------------------------------------------------------------------------
# Outputs are values Terraform prints after `apply` (and that other configs can
# consume). Great for surfacing IDs you'd otherwise have to hunt for in the
# portal. Here we echo back who/what we authenticated as, to confirm the setup.
# ------------------------------------------------------------------------------

output "authenticated_tenant_id" {
  description = "The tenant Terraform authenticated against (should match var.tenant_id)."
  value       = data.azuread_client_config.current.tenant_id
}

output "authenticated_object_id" {
  description = "Object ID of the identity Terraform is running as (your user or a service principal)."
  value       = data.azuread_client_config.current.object_id
}
