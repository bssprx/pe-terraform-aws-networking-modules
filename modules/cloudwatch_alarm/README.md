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
| [aws_cloudwatch_metric_alarm.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | List of ARNs to notify when the alarm state is triggered | `list(string)` | `[]` | no |
| <a name="input_alarm_description"></a> [alarm\_description](#input\_alarm\_description) | Description of the alarm | `string` | `""` | no |
| <a name="input_alarm_name"></a> [alarm\_name](#input\_alarm\_name) | Name of the CloudWatch alarm | `string` | n/a | yes |
| <a name="input_comparison_operator"></a> [comparison\_operator](#input\_comparison\_operator) | Comparison operator for the alarm | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Metric dimensions | `map(string)` | `{}` | no |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | Number of periods over which data is compared to the threshold | `number` | `1` | no |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | Name of the CloudWatch metric to alarm on | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | CloudWatch namespace of the metric | `string` | n/a | yes |
| <a name="input_period"></a> [period](#input\_period) | Period in seconds over which the metric is evaluated | `number` | n/a | yes |
| <a name="input_statistic"></a> [statistic](#input\_statistic) | Statistic to apply to the metric | `string` | `"Average"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the alarm | `map(string)` | `{}` | no |
| <a name="input_threshold"></a> [threshold](#input\_threshold) | Threshold value for the alarm | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_arn"></a> [alarm\_arn](#output\_alarm\_arn) | ARN of the CloudWatch alarm |
| <a name="output_alarm_name"></a> [alarm\_name](#output\_alarm\_name) | Name of the CloudWatch alarm |
