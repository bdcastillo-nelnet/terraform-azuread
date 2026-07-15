output "environment" {
  description = "The environment this run targeted."
  value       = var.environment
}

output "authenticated_tenant_id" {
  description = "Tenant Terraform authenticated against (should match var.tenant_id)."
  value       = data.azuread_client_config.current.tenant_id
}

output "authenticated_object_id" {
  description = "Object ID of the identity Terraform is running as."
  value       = data.azuread_client_config.current.object_id
}

output "users" {
  description = "Users managed from users.csv, keyed by username."
  value       = module.users.users
}
