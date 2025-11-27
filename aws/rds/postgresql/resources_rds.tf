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
  engine_version                      = "18.1"
  final_snapshot_identifier           = "${var.name_prefix}-rds-postgres-final"
  iam_database_authentication_enabled = false
  identifier_prefix                   = "${replace(var.name_prefix, "_", "-")}-"
  instance_class                      = "db.t4g.micro"
  iops                                = null
  license_model                       = "postgresql-license"
  maintenance_window                  = "sat:06:50-sat:07:20"
  max_allocated_storage               = 500
  multi_az                            = false
  db_name                             = var.db_name != null ? var.db_name : replace(var.name_prefix, "-", "_")
  option_group_name                   = aws_db_option_group.main.id
  parameter_group_name                = aws_db_parameter_group.main.id
  password                            = random_password.rds_password.result
  performance_insights_enabled        = false
  performance_insights_kms_key_id     = data.aws_kms_key.rds.arn
  port                                = 5432
  publicly_accessible                 = false
  skip_final_snapshot                 = false
  storage_encrypted                   = true
  storage_type                        = "gp3"
  username                            = var.username != null ? var.username : replace(var.name_prefix, "-", "_")
  vpc_security_group_ids              = [aws_security_group.main.id]
}

resource "aws_db_parameter_group" "main" {
  family      = "postgres18"
  name_prefix = "${replace(var.name_prefix, "_", "-")}-"
  description = "The parameter group for ${var.name_prefix}"

  dynamic "parameter" {
    for_each = var.db_params
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
  name_prefix              = "${replace(var.name_prefix, "_", "-")}-"
  option_group_description = "The option group for ${var.name_prefix}"
  engine_name              = "postgres"
  major_engine_version     = "18"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "main" {
  name_prefix = "${var.name_prefix}-"
  description = "The default subnet group for ${var.name_prefix}"
  subnet_ids  = var.private_subnet_ids

  lifecycle {
    create_before_destroy = true
  }
}
