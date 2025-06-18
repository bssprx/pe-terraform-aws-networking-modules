# NAT Gateway Module

This module creates a single AWS NAT Gateway and Elastic IP address in a specified public subnet. It is typically used in combination with private subnets to enable outbound internet access.

<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name_prefix](#input_name_prefix) | Prefix to use for naming the NAT Gateway | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet_id](#input_subnet_id) | The ID of the public subnet in which to place the NAT Gateway | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input_tags) | Tags to apply to the NAT Gateway and associated resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_id"></a> [nat_gateway_id](#output_nat_gateway_id) | The ID of the NAT Gateway |

<!-- END_TF_DOCS -->
