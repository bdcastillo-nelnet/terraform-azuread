# terraform-azuread

Terraform configuration for managing **Azure AD (Microsoft Entra ID)** with the
[`azuread`](https://registry.terraform.io/providers/hashicorp/azuread/latest) provider.
Learning project — tracked in Jira **NN-15153**.

## What this manages

Identity objects in an Entra tenant: **users, groups, applications, and service
principals (Enterprise Applications)**.

It does **not** manage Azure infrastructure (VMs, storage, networking) — that is
the separate `azurerm` provider.

## Prerequisites

- Terraform >= 1.5
- Azure CLI (`az`)
- Access to the relevant Azure AD tenant

## Repository layout

```
terraform-azuread/
├─ README.md
├─ .gitignore
├─ modules/
│  └─ identity/          # reusable logic, written ONCE and shared by all environments
│     ├─ versions.tf     # which providers this module needs
│     ├─ main.tf         # resources & data sources (users, groups, apps …)
│     └─ outputs.tf      # values the module returns to its caller
└─ environments/
   ├─ sandbox/           # a "root module" — has its own state
   │  ├─ providers.tf              # Terraform + provider version pins, provider config
   │  ├─ variables.tf              # inputs this environment accepts
   │  ├─ main.tf                   # calls ../../modules/identity
   │  ├─ outputs.tf                # re-exports the module's outputs
   │  └─ sandbox.auto.tfvars       # this env's config (committed; no secrets)
   └─ prod/              # same shape, separate state, production values
```

### Why this shape

- **`modules/identity`** holds the actual resource definitions once. Both
  environments call it, so sandbox and prod never drift apart.
- **`environments/<env>`** are thin root modules. Each is a separate working
  directory, so each gets its **own state** — you cannot touch prod's state
  from the sandbox directory. That isolation is the whole point.
- **State isolation works even with local state today** (separate directories =
  separate `terraform.tfstate`). Moving each environment to a remote backend is
  a later step (NN-15163).

## Variables & secrets convention

- **Committed:** `*.auto.tfvars` holds non-secret, per-environment *config*
  (tenant IDs, names). Terraform auto-loads any `*.auto.tfvars` in the working
  directory. Committing it makes each environment fully described in the repo.
- **Never committed:** secrets. They come from `az login`, `TF_VAR_*`
  environment variables, or a secrets store — never from a tfvars file.
  `.gitignore` blocks `terraform.tfvars`, `*.secret.tfvars`, and state files as
  guardrails.

## Getting started (sandbox)

```bash
az login --tenant <sandbox-tenant-id>   # authenticate

cd environments/sandbox                 # pick the environment
terraform init                          # download provider, wire up the module
terraform plan                          # preview — ALWAYS read before applying
terraform apply                         # make it so
```

Prod uses the identical commands from `environments/prod` once its tenant ID is
filled in.

## Safety rules

- **Run from one environment directory at a time.** The directory you're in
  determines which tenant and state you affect.
- **Always** review `terraform plan` output before `terraform apply`.
- Secrets never go in tfvars. State files are git-ignored.
- Commit `.terraform.lock.hcl` (per environment) so provider versions are pinned
  for everyone.
