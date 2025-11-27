locals {
  # Defines the IPV4 CIDR block for Internet
  wildcard_ipv4 = "0.0.0.0/0"

  # Defines the IPV6 CIDR block for Internet
  wildcard_ipv6 = "::/0"

  credentials = { for username in var.usernames : username => random_password.passwords[username].result }

  user_data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
    vpn_domain          = var.domain_name
    vpn_users           = local.credentials
    private_cidr_blocks = var.private_cidr_blocks
    vpn_client_pool     = var.client_pool
  })

  # Ensure that all variables are declared here in order to overwrite the value if necessary
  name_prefix             = var.name_prefix
  subnet_id               = var.subnet_id
  private_cidr_blocks     = var.private_cidr_blocks
  private_route_table_ids = var.private_route_table_ids
  domain_name             = var.domain_name
  usernames               = var.usernames
  client_pool             = var.client_pool
}
