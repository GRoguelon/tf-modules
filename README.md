# OpenTofu / Terraform modules

This repository regroups different modules that can be used to deploy different kind of applications.

## Amazon Web Services

### Network

Deploy a VPC and public/private subnets in AWS.

#### Example

```hcl
module "network" {
  source = "github.com/GRoguelon/tf-modules//aws/network"

  name_prefix         = "my-project"
  enable_vpc_ipv6     = false
  vpc_cidr_block      = "10.0.0.0/16"
  nbr_public_subnets  = 3
  nbr_private_subnets = 3
  nbr_nat_gateways    = 3
}
```

### StrongSwan VPN

Deploy a StrongSwan VPN and generate credentials for `usernames`.

#### Example

```hcl
module "vpn" {
  source = "github.com/GRoguelon/tf-modules//aws/vpn/strongswan"

  name_prefix             = "my-project"
  subnet_id               = "subnet-01248371de43fd6e0"
  private_route_table_ids = toset(["rtb-0e6307bd892bc7a62"])
  domain_name             = "vpn.example.com"
  usernames               = ["john@example.com"]
  client_pool             = "10.10.10.0/24"
}
```
