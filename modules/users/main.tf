resource "random_password" "user" {
  for_each = var.users
  length   = 24
}

resource "azuread_user" "user" {
  for_each = var.users

  display_name          = "${each.value.first_name} ${each.value.last_name}"
  user_principal_name   = "${each.key}@${var.domain}"
  mail_nickname         = each.key
  department            = each.value.department
  job_title             = each.value.job_title
  password              = random_password.user[each.key].result
  force_password_change = var.force_password_change
}
