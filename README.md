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

```
terraform-azuread/
├─ README.md          # this file (describes the whole repo)
├─ .gitignore         # keeps state files and secrets out of git
└─ identity/          # Terraform root module — run all commands from here
   ├─ providers.tf              # Terraform + provider version pins and provider config
   ├─ variables.tf              # input variables (the module's "arguments")
   ├─ main.tf                   # resources and data sources
   ├─ outputs.tf                # values printed after `apply`
   └─ terraform.tfvars.example  # template — copy to terraform.tfvars and fill in
```

Terraform loads *all* `.tf` files in the directory it runs in, so the file
names inside `identity/` are a human convention, not a requirement. The
`identity/` folder itself is the "root module" — the directory you run
Terraform from.

## Getting started

```bash
# 1. Log in to your sandbox tenant
az login --tenant <your-tenant-id>

# 2. Enter the module
cd identity

# 3. Provide your tenant ID
cp terraform.tfvars.example terraform.tfvars
#   then edit terraform.tfvars

# 4. Initialize (downloads the azuread provider)
terraform init

# 5. Preview changes — ALWAYS read this before applying
terraform plan

# 6. Apply
terraform apply
```

## Safety rules

- **Sandbox only.** Do not point this at production.
- **Always** review `terraform plan` output before `terraform apply`.
- `terraform.tfvars` and `*.tfstate` are git-ignored — never commit secrets.
- Commit `.terraform.lock.hcl` so the whole team uses identical provider versions.
