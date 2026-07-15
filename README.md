# terraform-azuread

Terraform configuration for managing **Azure AD (Microsoft Entra ID)** with the
[`azuread`](https://registry.terraform.io/providers/hashicorp/azuread/latest) provider.
Sandbox / learning project — tracked in Jira **NN-15153**.

## What this manages

Identity objects in an Entra tenant: **users, groups, applications, and service
principals (Enterprise Applications)**.

It does **not** manage Azure infrastructure (VMs, storage, networking) — that is
the separate `azurerm` provider.

## Prerequisites

- Terraform >= 1.5
- Azure CLI (`az`)
- Access to an Azure AD **sandbox** tenant (never run this against production)

## Repository layout

| File | Purpose |
|------|---------|
| `providers.tf` | Terraform + provider version pins and provider config |
| `variables.tf` | Input variables (the project's "arguments") |
| `main.tf` | Resources and data sources |
| `outputs.tf` | Values printed after `apply` |
| `terraform.tfvars.example` | Template — copy to `terraform.tfvars` and fill in |
| `.gitignore` | Keeps state files and secrets out of git |

Terraform loads *all* `.tf` files in this directory, so these names are a
human convention, not a requirement.

## Getting started

```bash
# 1. Log in to your sandbox tenant
az login --tenant <your-tenant-id>

# 2. Provide your tenant ID
cp terraform.tfvars.example terraform.tfvars
#   then edit terraform.tfvars

# 3. Initialize (downloads the azuread provider)
terraform init

# 4. Preview changes — ALWAYS read this before applying
terraform plan

# 5. Apply
terraform apply
```

## Safety rules

- **Sandbox only.** Do not point this at production.
- **Always** review `terraform plan` output before `terraform apply`.
- `terraform.tfvars` and `*.tfstate` are git-ignored — never commit secrets.
- Commit `.terraform.lock.hcl` so the whole team uses identical provider versions.
