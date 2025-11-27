resource "random_password" "rds_password" {
  length           = 64
  special          = true
  override_special = "!$%&*-_=+<>"
  upper            = true
  lower            = true
  numeric          = true
}
