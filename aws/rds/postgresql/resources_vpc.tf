resource "aws_security_group" "main" {
  vpc_id                 = var.vpc_id
  name_prefix            = "${var.name_prefix}-sg-rds-postgresql-"
  description            = "The security group for ${var.name_prefix}"
  revoke_rules_on_delete = true

  tags = {
    Name = "${var.name_prefix}-sg-rds-postgresql"
  }

  lifecycle {
    create_before_destroy = true
  }
}
