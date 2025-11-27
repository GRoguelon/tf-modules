resource "aws_vpc" "main" {
  cidr_block                           = local.vpc_cidr_block
  instance_tenancy                     = "default"
  assign_generated_ipv6_cidr_block     = local.enable_vpc_ipv6
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  enable_dns_hostnames                 = true

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "${local.name_prefix}-rt-default"
  }
}

resource "aws_subnet" "public" {
  count = local.nbr_public_subnets

  vpc_id                                         = aws_vpc.main.id
  cidr_block                                     = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index * 2)
  availability_zone                              = data.aws_availability_zones.available.names[count.index % local.nbr_public_subnets]
  map_public_ip_on_launch                        = true
  assign_ipv6_address_on_creation                = local.enable_vpc_ipv6
  enable_dns64                                   = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  enable_resource_name_dns_a_record_on_launch    = false
  ipv6_cidr_block                                = local.enable_vpc_ipv6 ? cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index * 2) : null
  ipv6_native                                    = false

  tags = {
    Name             = "${local.name_prefix}-subnet-public-${count.index}"
    Tier             = "public"
    AvailabilityZone = data.aws_availability_zones.available.names[count.index % local.nbr_public_subnets]
  }
}

resource "aws_subnet" "private" {
  count = local.nbr_private_subnets

  vpc_id                                         = aws_vpc.main.id
  cidr_block                                     = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index * 2 + 1)
  availability_zone                              = data.aws_availability_zones.available.names[count.index % local.nbr_private_subnets]
  map_public_ip_on_launch                        = false
  assign_ipv6_address_on_creation                = local.enable_vpc_ipv6
  enable_dns64                                   = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  enable_resource_name_dns_a_record_on_launch    = false
  ipv6_cidr_block                                = local.enable_vpc_ipv6 ? cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index * 2 + 1) : null
  ipv6_native                                    = false

  tags = {
    Name             = "${local.name_prefix}-subnet-private-${count.index}"
    Tier             = "private"
    AvailabilityZone = data.aws_availability_zones.available.names[count.index % local.nbr_public_subnets]
  }
}

resource "aws_internet_gateway" "main" {
  count = local.nbr_public_subnets > 0 ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-igw"
    Tier = "public"
  }
}

resource "aws_egress_only_internet_gateway" "main" {
  count = local.nbr_public_subnets > 0 && local.enable_vpc_ipv6 ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-eigw"
    Tier = "public"
  }
}

resource "aws_nat_gateway" "main" {
  count = local.nbr_nat_gateways

  subnet_id     = aws_subnet.public[count.index % local.nbr_public_subnets].id
  allocation_id = aws_eip.nat[count.index].id
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name             = "${local.name_prefix}-nat-${count.index}"
    AvailabilityZone = aws_subnet.public[count.index % local.nbr_public_subnets].availability_zone
  }
}

resource "aws_eip" "nat" {
  count = local.nbr_nat_gateways

  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-eip-nat-${count.index}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "public" {
  count = local.nbr_public_subnets > 0 ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-rt-igw"
    Tier = "public"
  }
}

resource "aws_route_table_association" "public" {
  count = local.nbr_public_subnets

  route_table_id = aws_route_table.public[0].id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_route_table" "private" {
  count = local.nbr_nat_gateways

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-rt-nat-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count = local.nbr_nat_gateways > 0 ? local.nbr_private_subnets : 0

  route_table_id = aws_route_table.private[count.index % local.nbr_nat_gateways].id
  subnet_id      = aws_subnet.private[count.index].id
}

resource "aws_route" "public_internet" {
  count = local.nbr_public_subnets > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = local.wildcard_ipv4
  gateway_id             = aws_internet_gateway.main[count.index].id
}

resource "aws_route" "public_internet_ipv6" {
  count = local.nbr_public_subnets > 0 && local.enable_vpc_ipv6 ? 1 : 0

  route_table_id              = aws_route_table.public[count.index].id
  destination_ipv6_cidr_block = local.wildcard_ipv6
  egress_only_gateway_id      = aws_egress_only_internet_gateway.main[count.index].id
}

resource "aws_route" "private_nat" {
  count = local.nbr_nat_gateways

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = local.wildcard_ipv4
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}
