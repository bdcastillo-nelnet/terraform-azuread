output "users" {
  description = "Created users keyed by username."
  value = {
    for k, u in azuread_user.user : k => {
      object_id           = u.object_id
      user_principal_name = u.user_principal_name
      display_name        = u.display_name
    }
  }
}
