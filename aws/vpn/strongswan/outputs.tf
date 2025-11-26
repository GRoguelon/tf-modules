output "public_ip" {
  description = "Outputs the public IP of the EC2 instance"
  value       = aws_eip.main.public_ip
}

output "instance_id" {
  description = "Outputs the EC2 instance ID"
  value       = aws_instance.main.id
}

output "security_group_id" {
  description = "Outputs the Security Group ID"
  value       = aws_security_group.main.id
}

output "credentials" {
  description = "Outputs the VPN credentials"
  sensitive   = true
  value       = local.credentials
}
