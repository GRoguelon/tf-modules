output "vpc" {
  description = "Outputs the AWS VPC"
  value = aws_vpc.main
}

output "vpc_nat_eips" {
  description = "Outputs the list of AWS EIP attached to the NAT gateways"
  value = [for eip in aws_eip.nat : eip.public_ip]
}

output "public_subnets" {
  description = "Outputs the list of AWS public subnets"
  value = aws_subnet.public
}

output "private_subnets" {
  description = "Outputs the list of AWS private subnets"
  value = aws_subnet.private
}

output "private_route_tables" {
  description = "Outputs the list of AWS route tables for the private subnet"
  value = aws_route_table.private
}

output "public_route_table" {
  description = "Outputs the AWS route table for the public subnet"
  value = aws_route_table.public.id
}
