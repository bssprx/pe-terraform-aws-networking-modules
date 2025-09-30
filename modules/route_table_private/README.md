# Route Table Private Module

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private_mutable](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private_protected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix to use for naming | `string` | n/a | yes |
| <a name="input_nat_gateway_ids_by_az"></a> [nat\_gateway\_ids\_by\_az](#input\_nat\_gateway\_ids\_by\_az) | Map of NAT Gateway IDs keyed by AZ | `map(string)` | n/a | yes |
| <a name="input_prevent_destroy"></a> [prevent\_destroy](#input\_prevent\_destroy) | Whether to enable the prevent\_destroy lifecycle rule on private route tables | `bool` | `true` | no |
| <a name="input_private_subnet_ids_by_az"></a> [private\_subnet\_ids\_by\_az](#input\_private\_subnet\_ids\_by\_az) | Map of private subnet IDs keyed by AZ | `map(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the route tables | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_route_table_ids_by_az"></a> [private\_route\_table\_ids\_by\_az](#output\_private\_route\_table\_ids\_by\_az) | Map of private route table IDs keyed by AZ |
<!-- END_TF_DOCS -->
