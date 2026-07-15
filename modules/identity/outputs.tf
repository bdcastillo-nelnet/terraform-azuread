output "tenant_id" {
  description = "Tenant the module authenticated against."
  value       = data.azuread_client_config.current.tenant_id
}

output "object_id" {
  description = "Object ID of the identity Terraform is running as."
  value       = data.azuread_client_config.current.object_id
}
