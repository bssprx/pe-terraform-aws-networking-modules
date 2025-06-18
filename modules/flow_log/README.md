# flow_log

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
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eni_id"></a> [eni_id](#input_eni_id) | Optional: ID of the network interface to enable flow logs for | `string` | `null` | no |
| <a name="input_iam_role_arn"></a> [iam_role_arn](#input_iam_role_arn) | IAM role ARN to use for delivering flow logs | `string` | n/a | yes |
| <a name="input_log_group_arn"></a> [log_group_arn](#input_log_group_arn) | ARN of the CloudWatch log group | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet_id](#input_subnet_id) | Optional: ID of the subnet to enable flow logs for | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Tags to apply to the flow log | `map(string)` | `{}` | no |
| <a name="input_target_resource"></a> [target_resource](#input_target_resource) | The resource ID to enable flow logs for (vpc_id, subnet_id, or eni_id) | `string` | `null` | no |
| <a name="input_traffic_type"></a> [traffic_type](#input_traffic_type) | Type of traffic to log. Valid values: ACCEPT, REJECT, or ALL. | `string` | `"REJECT"` | no |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id) | ID of the VPC to enable flow logs for | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output_arn) | The ARN of the flow log |
| <a name="output_id"></a> [id](#output_id) | The ID of the flow log |
<!-- END_TF_DOCS -->
