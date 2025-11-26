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
}

variable "nbr_private_subnets" {
  description = "Defines the number of private subnets to create in the VPC"
  type        = number
  default     = 3
}

variable "nbr_nat_gateways" {
  description = "Defines the number of NAT gateways to create in the VPC (1..nbr_private_subnets)"
  type        = number
  default     = 3
}
