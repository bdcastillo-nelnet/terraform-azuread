output "authenticated_tenant_id" {
  description = "Tenant Terraform authenticated against (should match var.tenant_id)."
  value       = module.identity.tenant_id
}

output "authenticated_object_id" {
  description = "Object ID of the identity Terraform is running as."
  value       = module.identity.object_id
}
