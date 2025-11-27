resource "aws_security_group" "main" {
  vpc_id                 = local.vpc_id
  name_prefix            = "${local.name_prefix}-sg-rds-postgresql-"
  description            = "The security group for ${local.name_prefix}"
  revoke_rules_on_delete = true

  tags = {
    Name = "${local.name_prefix}-sg-rds-postgresql"
  }

  lifecycle {
    create_before_destroy = true
  }
}
