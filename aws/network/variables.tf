variable "name_prefix" {
  description = "Defines the name prefix used to generate resource name"
  type        = string
}

variable "enable_vpc_ipv6" {
  description = "Defines the VPC CIDR block"
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "Defines the VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "nbr_public_subnets" {
  description = "Defines the number of public subnets to create in the VPC"
  type        = number
  default     = 3

  validation {
    condition     = can(tonumber(var.nbr_public_subnets)) && floor(tonumber(var.nbr_public_subnets)) == tonumber(var.nbr_public_subnets) && var.nbr_public_subnets >= 0
    error_message = "The nbr_public_subnets must be an integer greater or equal to 0."
  }
}

variable "nbr_private_subnets" {
  description = "Defines the number of private subnets to create in the VPC"
  type        = number
  default     = 3

  validation {
    condition     = can(tonumber(var.nbr_private_subnets)) && floor(tonumber(var.nbr_private_subnets)) == tonumber(var.nbr_private_subnets) && var.nbr_private_subnets >= 0
    error_message = "The nbr_private_subnets must be an integer greater or equal to 0."
  }
}

variable "nbr_nat_gateways" {
  description = "Defines the number of NAT gateways to create in the VPC (1..nbr_private_subnets)"
  type        = number
  default     = null

  validation {
    condition     = var.nbr_nat_gateways == null || can(tonumber(var.nbr_nat_gateways)) && floor(tonumber(var.nbr_nat_gateways)) == tonumber(var.nbr_nat_gateways) && var.nbr_nat_gateways >= 0
    error_message = "The nbr_nat_gateways must be null or an integer greater or equal to 0."
  }
}
