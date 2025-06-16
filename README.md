# PE Terraform AWS Networking Modules

Reusable Terraform modules for AWS networking patterns, including VPCs, subnets, flow logs, and IAM roles.

## Usage

```hcl
module "vpc" {
  source = "git::https://github.com/patientengineer/pe-terraform-aws-networking-modules.git//modules/vpc?ref=v0.1.0"
  name   = "pe-network"
  cidr   = "10.0.0.0/16"
}