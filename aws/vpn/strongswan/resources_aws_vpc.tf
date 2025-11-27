resource "aws_security_group" "main" {
  vpc_id                 = data.aws_subnet.main.vpc_id
  name_prefix            = "${var.name_prefix}-sg-vpn-"
  description            = "Security group for StrongSwan VPN server"
  revoke_rules_on_delete = true

  tags = {
    Name = "${var.name_prefix}-sg-vpn"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "ikev2_ipv6" {
  description       = "Egress IPV6 UDP (500 / IKEv2) traffic from Internet"
  security_group_id = aws_security_group.main.id
  from_port         = 500
  to_port           = 500
  ip_protocol       = "udp"
  cidr_ipv6         = "::/0"

  tags = {
    Name = "${var.name_prefix}-sg-ingress-ipv4_udp_500-internet"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ikev2_ipv4" {
  description       = "Egress IPV4 UDP (500 / IKEv2) traffic from Internet"
  security_group_id = aws_security_group.main.id
  from_port         = 500
  to_port           = 500
  ip_protocol       = "udp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.name_prefix}-sg-ingress-ipv4_udp_500-internet"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ikev2_nat_t_ipv6" {
  description       = "Egress IPV6 UDP (500 / IKEv2 NAT-T) traffic from Internet"
  security_group_id = aws_security_group.main.id
  from_port         = 4500
  to_port           = 4500
  ip_protocol       = "udp"
  cidr_ipv6         = "::/0"

  tags = {
    Name = "${var.name_prefix}-sg-ingress-ipv4_udp_4500-internet"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ikev2_nat_t_ipv4" {
  description       = "Egress IPV4 UDP (4500 / IKEv2 NAT-T) traffic from Internet"
  security_group_id = aws_security_group.main.id
  from_port         = 4500
  to_port           = 4500
  ip_protocol       = "udp"
  cidr_ipv4         = "0.0.0.0/0"


  tags = {
    Name = "${var.name_prefix}-sg-ingress-ipv4_udp_4500-internet"
  }
}

resource "aws_vpc_security_group_egress_rule" "all_ipv4" {
  description       = "Egress IPV4 traffic to Internet"
  security_group_id = aws_security_group.main.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.name_prefix}-sg-egress-ipv4-internet"
  }
}

resource "aws_vpc_security_group_egress_rule" "all_ipv6" {
  description       = "Egress IPV6 traffic to Internet"
  security_group_id = aws_security_group.main.id
  ip_protocol       = "-1"
  cidr_ipv6         = "::/0"

  tags = {
    Name = "${var.name_prefix}-sg-egress-ipv6-internet"
  }
}

resource "aws_route" "vpn_clients" {
  for_each = toset(var.private_route_table_ids)

  route_table_id         = each.key
  destination_cidr_block = var.client_pool
  network_interface_id   = aws_instance.main.primary_network_interface_id
}
