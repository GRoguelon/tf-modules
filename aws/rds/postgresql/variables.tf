variable "name_prefix" {
  description = "Defines the name prefix used to generate resource name"
  type        = string
}

variable "vpc_id" {
  description = "Defines the AWS VPC ID"
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "The vpc_id value must be a valid VPC id, starting with \"vpc-\"."
  }
}

variable "private_subnet_ids" {
  description = "Defines the AWS Private Subnet IDs"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) > 0
    error_message = "The private_subnet_ids list can't be empty."
  }
}

variable "username" {
  description = "Defines the database username"
  type        = string
  default     = null
}

variable "db_name" {
  description = "Defines the database name"
  type        = string
  default     = null
}

variable "db_params" {
  description = "Defines the DB parameters applied"
  type        = map(string)
  default     = {}
}

variable "db_version" {
  description = "Defines the version of PostgreSQL"
  type        = string
  default     = "18.1"

  validation {
    condition     = contains(["16.6", "16.8", "16.9", "16.10", "16.11", "17.2", "17.4", "17.5", "17.6", "17.7", "18.1"], var.db_version)
    error_message = "The version must be one of 16.6, 16.8, 16.9, 16.10, 16.11, 17.2, 17.4, 17.5, 17.6, 17.7, 18.1"
  }
}

variable "instance_type" {
  description = "Defines the type of the RDS instance"
  type        = string
  default     = "db.t4g.micro"

  validation {
    condition     = length(var.instance_type) > 0 && substr(var.instance_type, 0, 3) == "db."
    error_message = "The instance_type value must be a valid RDS instance type, starting with \"db.\"."
  }
}

variable "multi_az" {
  description = "Defines if the database is deployed accross several AZs"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Defines if the database is publicly available on Internet"
  type        = bool
  default     = false
}
