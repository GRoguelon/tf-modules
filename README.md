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

  # Optional:
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
  private_cidr_blocks     = ["10.0.1.0/24"]
  domain_name             = "vpn.example.com"
  usernames               = ["john@example.com"]

  # Optional:
  private_route_table_ids = ["rtb-0e6307bd892bc7a62"]
  client_pool             = "10.10.10.0/24"
}
```

### AWS RDS - PostgreSQL

Deploy AWS RDS PostgreSQL 18.1 in a single AZ.

#### Example

```hcl
module "vpn" {
  source = "github.com/GRoguelon/tf-modules//aws/vpn/strongswan"

  name_prefix        = "my-project"
  vpc_id             = "vpc-029f4c625dc8af123"
  private_subnet_ids = ["subnet-01248371de43f23e4", "subnet-0ae926be1212e84f3"]

  # Optional:
  username           = "my-username"
  db_name            = "my-db-name"
  db_params          = {
    log_connections = 1
  }
}
```
