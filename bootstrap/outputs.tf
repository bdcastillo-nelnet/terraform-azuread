output "ci_client_id" {
  description = "Set as the AZURE_CLIENT_ID GitHub Actions variable."
  value       = azuread_application.ci.client_id
}

output "tenant_id" {
  description = "Set as the AZURE_TENANT_ID GitHub Actions variable."
  value       = var.tenant_id
}

output "subscription_id" {
  description = "Set as the AZURE_SUBSCRIPTION_ID GitHub Actions variable."
  value       = var.subscription_id
}
