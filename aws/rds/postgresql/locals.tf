locals {
  hostname = split(":", aws_db_instance.main.endpoint)[0]

  # Ensure that all variables are declared here in order to overwrite the value if necessary
  name_prefix         = var.name_prefix
  vpc_id              = var.vpc_id
  private_subnet_ids  = var.private_subnet_ids
  username            = var.username
  db_name             = var.db_name
  db_params           = var.db_params
  version             = var.db_version
  major_version       = split(".", local.version)[0]
  instance_type       = var.instance_type
  multi_az            = var.multi_az
  publicly_accessible = var.publicly_accessible
}
