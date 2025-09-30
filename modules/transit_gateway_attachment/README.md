# Transit Gateway Attachment

This module creates an AWS Transit Gateway VPC Attachment to allow communication between a VPC and a Transit Gateway.

## Usage

```hcl
module "transit_gateway_attachment" {
  source = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/transit_gateway_attachment?ref=v0.4.0"

  name_prefix         = "example"
  vpc_id              = "vpc-abc123"
  subnet_ids          = ["subnet-abc123", "subnet-def456"]
  transit_gateway_id  = "tgw-abc123"
  tags = {
    Environment = "dev"
    Project     = "networking"
  }
}
```
<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_support"></a> [dns\_support](#input\_dns\_support) | Enable or disable DNS support for the TGW attachment (enable\|disable) | `string` | `"enable"` | no |
| <a name="input_ipv6_support"></a> [ipv6\_support](#input\_ipv6\_support) | Enable or disable IPv6 support for the TGW attachment (enable\|disable) | `string` | `"disable"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for naming resources | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of private subnet IDs for TGW attachment | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for resources | `map(string)` | `{}` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | Transit Gateway ID | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to attach to the Transit Gateway | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the Transit Gateway VPC Attachment |
| <a name="output_state"></a> [state](#output\_state) | The current state of the TGW VPC attachment |
<!-- END_TF_DOCS -->
