variable "users" {
  description = "Users to create, keyed by username. Values hold raw person data from users.csv."
  type = map(object({
    first_name = string
    last_name  = string
    department = string
    job_title  = string
  }))
}

variable "domain" {
  description = "Verified tenant domain used to build user principal names (e.g. contoso.onmicrosoft.com)."
  type        = string
}

variable "force_password_change" {
  description = "Require users to change their password at next sign-in."
  type        = bool
  default     = true
}
