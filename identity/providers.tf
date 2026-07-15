terraform {
  required_version = ">= 1.5"

  # State lives in Azure Storage. Per-environment values are supplied at init
  # via -backend-config (see vars/<env>.backend.hcl).
  backend "azurerm" {

  }

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
}
