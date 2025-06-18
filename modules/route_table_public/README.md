# route_table_public

Creates a public route table and associates it with public subnets in a VPC.

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
| [aws_route.public_internet_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_internet_gateway_id"></a> [internet_gateway_id](#input_internet_gateway_id) | ID of the Internet Gateway | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name_prefix](#input_name_prefix) | Prefix used to construct resource names | `string` | n/a | yes |
| <a name="input_public_subnet_ids_by_az"></a> [public_subnet_ids_by_az](#input_public_subnet_ids_by_az) | Map of availability zones to public subnet IDs | `map(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input_tags) | Map of tags to apply to resources | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id) | The ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output_id) | The ID of the public route table |
<!-- END_TF_DOCS -->
