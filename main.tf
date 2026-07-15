# main.tf
# ------------------------------------------------------------------------------
# Where the actual resources live. Right now it holds a single read-only
# "smoke test" so we can confirm authentication works BEFORE we create anything.
# We'll add real resources (users, groups, apps) in later subtasks.
# ------------------------------------------------------------------------------

# A DATA SOURCE reads existing information — it never creates, changes, or
# deletes anything. `azuread_client_config` returns details about the identity
# Terraform is currently authenticated as. It's the safest possible thing to
# run, which makes it a perfect first test.
data "azuread_client_config" "current" {}
