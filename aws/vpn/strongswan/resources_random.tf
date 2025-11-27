resource "random_password" "passwords" {
  for_each = local.usernames

  length  = 36
  special = true
  upper   = true
  lower   = true
  numeric = true
}
