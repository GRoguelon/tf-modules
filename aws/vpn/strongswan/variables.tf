variable "name_prefix" {
  description = "Defines the name prefix used to generate resource name"
  type        = string
}

variable "subnet_id" {
  description = "Defines the AWS subnet ID where to deploy the AWS EC2 instance"
  type        = string
}

variable "private_cidr_blocks" {
  description = "Defines the AWS private subnet CIDR blocks"
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "Defines the AWS private route table IDs"
  type        = list(string)
  default     = []
}

variable "domain_name" {
  description = "Defines the domain name attached the VPN instance (vpn.example.com)"
  type        = string
}

variable "usernames" {
  description = "Defines the set of usernames to grant access on the VPN instance"
  type        = set(string)
}

variable "client_pool" {
  description = "Defines the CIDR block associated to the client pool"
  type        = string
  default     = "10.10.10.0/24"
}
