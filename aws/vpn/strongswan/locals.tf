locals {
  credentials = { for username in var.usernames : username => random_password.passwords[username].result }

  user_data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
    vpn_domain          = var.domain_name
    vpn_users           = local.credentials
    private_cidr_blocks = var.private_cidr_blocks
    vpn_client_pool     = var.client_pool
  })
}
