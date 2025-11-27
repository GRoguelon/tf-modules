locals {
  # Defines the IPV4 CIDR block for Internet
  wildcard_ipv4 = "0.0.0.0/0"

  # Defines the IPV6 CIDR block for Internet
  wildcard_ipv6 = "::/0"

  # Ensure that all variables are declared here in order to overwrite the value if necessary
  name_prefix         = var.name_prefix
  vpc_cidr_block      = var.vpc_cidr_block
  enable_vpc_ipv6     = var.enable_vpc_ipv6
  nbr_public_subnets  = var.nbr_public_subnets
  nbr_private_subnets = var.nbr_private_subnets
  nbr_nat_gateways    = var.nbr_nat_gateways == null ? var.nbr_private_subnets : min(var.nbr_nat_gateways, var.nbr_private_subnets)
}
