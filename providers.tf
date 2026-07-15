# providers.tf
# ------------------------------------------------------------------------------
# This file tells Terraform two things:
#   1. Which version of Terraform and which providers this project needs.
#   2. How to configure the azuread provider (which tenant, how to authenticate).
# ------------------------------------------------------------------------------

terraform {
  # Pin the Terraform CLI version. ">= 1.5" because the `import` block feature
  # (which we'll rely on heavily later) was introduced in Terraform 1.5.
  required_version = ">= 1.5"

  required_providers {
    azuread = {
      # Where to download the provider from (the Terraform Registry).
      source = "hashicorp/azuread"
      # Version constraint. "~> 3.0" means ">= 3.0.0 and < 4.0.0" — we accept
      # bug-fix and minor updates, but never a major version that could break us.
      version = "~> 3.0"
    }
  }
}

# Configure the azuread provider itself.
provider "azuread" {
  # Which tenant (directory) to manage. Supplied via a variable so we never
  # hardcode an environment-specific ID into shared code.
  tenant_id = var.tenant_id

  # Note: we intentionally do NOT put credentials here. Authentication comes
  # from `az login` on your machine (Azure CLI auth). Terraform picks that up
  # automatically. No secrets in code = no secrets leaked to git.
}
