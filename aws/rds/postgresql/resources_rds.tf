resource "aws_db_instance" "main" {
  network_type                        = "IPV4"
  allocated_storage                   = 20
  allow_major_version_upgrade         = true
  apply_immediately                   = true
  auto_minor_version_upgrade          = true
  backup_retention_period             = 7
  backup_window                       = "04:00-04:30"
  ca_cert_identifier                  = "rds-ca-ecc384-g1"
  copy_tags_to_snapshot               = true
  db_subnet_group_name                = aws_db_subnet_group.main.id
  delete_automated_backups            = true
  deletion_protection                 = false
  enabled_cloudwatch_logs_exports     = []
  engine                              = "postgres"
  engine_version                      = local.version
  final_snapshot_identifier           = "${local.name_prefix}-rds-postgres-final"
  iam_database_authentication_enabled = false
  identifier_prefix                   = "${replace(local.name_prefix, "_", "-")}-"
  instance_class                      = local.instance_type
  license_model                       = "postgresql-license"
  maintenance_window                  = "sat:06:50-sat:07:20"
  max_allocated_storage               = 500
  multi_az                            = local.multi_az
  db_name                             = local.db_name != null ? local.db_name : replace(local.name_prefix, "-", "_")
  option_group_name                   = aws_db_option_group.main.id
  parameter_group_name                = aws_db_parameter_group.main.id
  password                            = random_password.rds_password.result
  performance_insights_enabled        = false
  performance_insights_kms_key_id     = data.aws_kms_key.rds.arn
  port                                = 5432
  publicly_accessible                 = local.publicly_accessible
  skip_final_snapshot                 = false
  storage_encrypted                   = true
  storage_type                        = "gp3"
  username                            = local.username != null ? local.username : replace(local.name_prefix, "-", "_")
  vpc_security_group_ids              = [aws_security_group.main.id]
}

resource "aws_db_parameter_group" "main" {
  family      = "postgres${local.major_version}"
  name_prefix = "${replace(local.name_prefix, "_", "-")}-"
  description = "The parameter group for ${local.name_prefix}"

  dynamic "parameter" {
    for_each = local.db_params
    iterator = parameter
    content {
      name  = parameter.key
      value = parameter.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_option_group" "main" {
  name_prefix              = "${replace(local.name_prefix, "_", "-")}-"
  option_group_description = "The option group for ${local.name_prefix}"
  engine_name              = "postgres"
  major_engine_version     = local.major_version

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "main" {
  name_prefix = "${local.name_prefix}-"
  description = "The default subnet group for ${local.name_prefix}"
  subnet_ids  = local.private_subnet_ids

  lifecycle {
    create_before_destroy = true
  }
}
