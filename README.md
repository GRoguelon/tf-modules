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
