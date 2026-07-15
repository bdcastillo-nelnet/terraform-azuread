output "authenticated_tenant_id" {
  description = "The tenant Terraform authenticated against (should match var.tenant_id)."
  value       = data.azuread_client_config.current.tenant_id
}

output "authenticated_object_id" {
  description = "Object ID of the identity Terraform is running as (your user or a service principal)."
  value       = data.azuread_client_config.current.object_id
}
