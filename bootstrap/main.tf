data "azuread_client_config" "current" {}

# Look up Microsoft Graph so we can reference its app-role IDs by name.
data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
}

# The application GitHub Actions will authenticate as.
resource "azuread_application" "ci" {
  display_name = "terraform-azuread-ci"

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]

    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["User.ReadWrite.All"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Group.ReadWrite.All"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.All"]
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "ci" {
  client_id = azuread_application.ci.client_id
}

# OIDC trust: GitHub mints short-lived tokens; these say which repo/refs to trust.
resource "azuread_application_federated_identity_credential" "main_branch" {
  application_id = azuread_application.ci.id
  display_name   = "github-main"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_repository}:ref:refs/heads/main"
}

resource "azuread_application_federated_identity_credential" "pull_request" {
  application_id = azuread_application.ci.id
  display_name   = "github-pull-request"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_repository}:pull_request"
}

# Admin consent for the Graph application permissions (granting the app roles
# to the CI service principal). Requires an admin to apply.
resource "azuread_app_role_assignment" "user_readwrite" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["User.ReadWrite.All"]
  principal_object_id = azuread_service_principal.ci.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "group_readwrite" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["Group.ReadWrite.All"]
  principal_object_id = azuread_service_principal.ci.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}

resource "azuread_app_role_assignment" "app_readwrite" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.All"]
  principal_object_id = azuread_service_principal.ci.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}

# Let the CI identity read/write the Terraform state blob (Entra RBAC, no keys).
resource "azurerm_role_assignment" "state_blob" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.state_resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.state_storage_account_name}"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.ci.object_id
}
