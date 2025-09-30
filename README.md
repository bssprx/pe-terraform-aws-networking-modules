# PE Terraform AWS Networking Modules

Reusable Terraform modules for AWS networking patterns, including VPCs, subnets, flow logs, and IAM roles.

## Usage

```hcl
module "vpc" {
  source = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/vpc?ref=v0.1.0"
  name   = "pe-network"
  cidr   = "10.0.0.0/16"
}
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
<!-- END_TF_DOCS -->