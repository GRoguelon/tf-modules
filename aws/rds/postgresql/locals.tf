locals {
  hostname = split(":", aws_db_instance.main.endpoint)[0]
}
