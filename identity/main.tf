data "azuread_client_config" "current" {}

data "azuread_domains" "default" {
  only_initial = true
}

locals {
  domain_name = data.azuread_domains.default.domains[0].domain_name
  users       = { for row in csvdecode(file("${path.module}/../users.csv")) : row.username => row }
}

module "users" {
  source = "../modules/users"

  users  = local.users
  domain = local.domain_name
}
