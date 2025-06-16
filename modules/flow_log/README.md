## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eni_id"></a> [eni\_id](#input\_eni\_id) | Optional: ID of the network interface to enable flow logs for | `string` | `null` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | IAM role ARN to use for delivering flow logs | `string` | n/a | yes |
| <a name="input_log_group_arn"></a> [log\_group\_arn](#input\_log\_group\_arn) | ARN of the CloudWatch log group | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Optional: ID of the subnet to enable flow logs for | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the flow log | `map(string)` | `{}` | no |
| <a name="input_target_resource"></a> [target\_resource](#input\_target\_resource) | The resource ID to enable flow logs for (vpc\_id, subnet\_id, or eni\_id) | `string` | `null` | no |
| <a name="input_traffic_type"></a> [traffic\_type](#input\_traffic\_type) | Type of traffic to log. Valid values: ACCEPT, REJECT, or ALL. | `string` | `"REJECT"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to enable flow logs for | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the flow log |
| <a name="output_id"></a> [id](#output\_id) | The ID of the flow log |
