# bootstrap

One-time foundation for CI. Provisions the identity GitHub Actions uses and
grants it the permissions it needs. **Run by a tenant admin, not by CI.**

Uses **local state** on purpose — this layer sets up the pieces the pipeline
depends on, so it must not depend on the pipeline.

## What it creates

- An Entra **application + service principal** (`terraform-azuread-ci`) for GitHub Actions.
- **Federated credentials** trusting GitHub OIDC tokens from `main` and pull requests (no stored secrets).
- **Microsoft Graph app permissions** (User/Group/Application `ReadWrite.All`) with admin consent, so CI can manage identity objects.
- A **Storage Blob Data Contributor** role assignment so CI can read/write the state blob via Entra (no storage keys).

## Prerequisites

You must be signed in (`az login`) as someone who can grant admin consent and
create role assignments (e.g. Global Administrator + Owner on the subscription).

## Run it

```bash
cd bootstrap
terraform init
terraform apply        # review the plan, then type: yes
```

## Then wire up GitHub

`terraform output` prints the three values to set as **GitHub Actions
Variables** (repo → Settings → Secrets and variables → Actions → Variables):

- `AZURE_CLIENT_ID`      = `ci_client_id`
- `AZURE_TENANT_ID`      = `tenant_id`
- `AZURE_SUBSCRIPTION_ID`= `subscription_id`

Then create a GitHub **Environment** named `sandbox` (repo → Settings →
Environments) and add yourself as a **required reviewer** — that becomes the
approval gate before `apply` runs.

After that, a pull request runs `plan`, and merging to `main` runs `apply`
(after approval).
