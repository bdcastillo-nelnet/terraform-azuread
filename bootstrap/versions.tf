terraform {
  required_version = ">= 1.5"

  # Local state ON PURPOSE: this layer provisions the identity/permissions that
  # the CI pipeline uses. It changes rarely and is run by an admin, not CI.
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}
