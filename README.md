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
├─ providers.tf     # Terraform + provider version pins, provider config
├─ variables.tf     # input variables
├─ main.tf          # resources & data sources
├─ outputs.tf       # values printed after apply
└─ vars/            # one file of values per environment (committed; no secrets)
   ├─ sandbox.tfvars
   └─ prod.tfvars   # placeholder until the prod tenant is known
```

A single configuration is reused for every environment; the environment is
selected at run time by passing the matching var file.

## Variables & secrets convention

- **Committed:** `vars/*.tfvars` hold non-secret, per-environment *config*
  (tenant ID, environment name). Committing them makes each environment fully
  described in the repo.
- **Never committed:** secrets. They come from `az login`, `TF_VAR_*`
  environment variables, or a secrets store — never from a tfvars file.
  `.gitignore` blocks `terraform.tfvars`, `*.secret.tfvars`, and state files.

## Getting started

```bash
az login --tenant <tenant-id>                    # authenticate

terraform init                                   # download provider
terraform plan  -var-file=vars/sandbox.tfvars    # preview — ALWAYS read first
terraform apply -var-file=vars/sandbox.tfvars    # make it so
```

Because the var files are not named `terraform.tfvars`, they are **not** loaded
automatically — you must pass `-var-file` on every `plan`/`apply`. That is
deliberate: it forces you to state which environment you are targeting.

## State isolation (important, and not done yet)

Right now a single local state file is shared across environments. That is fine
while **sandbox is the only real tenant**. Before a second environment (prod)
goes live, state MUST be isolated per environment, via either:

- **Terraform workspaces** — `terraform workspace new sandbox` / `prod`, or
- **Per-environment remote backend keys** (see NN-15163).

Until then, only run against the sandbox var file.

## Safety rules

- **Always** pass the correct `-var-file` and review `terraform plan` before `apply`.
- Secrets never go in tfvars. State files are git-ignored.
- Commit `.terraform.lock.hcl` so provider versions are pinned for everyone.
