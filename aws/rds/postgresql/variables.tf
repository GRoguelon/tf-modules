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
