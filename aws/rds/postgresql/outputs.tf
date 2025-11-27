output "hostname" {
  value = local.hostname
}

output "port" {
  value = aws_db_instance.main.port
}

output "db_name" {
  value = aws_db_instance.main.db_name
}

output "username" {
  value = aws_db_instance.main.username
}

output "password" {
  sensitive = true
  value     = aws_db_instance.main.password
}

output "database_url" {
  sensitive = true
  value     = "postgres://${aws_db_instance.main.username}:${aws_db_instance.main.password}@${local.hostname}:${aws_db_instance.main.port}/${aws_db_instance.main.db_name}"
}

output "security_group_id" {
  value = aws_security_group.main.id
}
