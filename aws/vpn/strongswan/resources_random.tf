resource "random_password" "passwords" {
  for_each = var.usernames

  length  = 36
  special = true
  upper   = true
  lower   = true
  numeric = true
}
