# cloudwatch_alarm

Creates a CloudWatch alarm for a specified metric with configurable threshold, evaluation period, and actions.

## Example Usage

```hcl
module "cloudwatch_alarm" {
  source = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/cloudwatch_alarm?ref=v0.5.0"

  alarm_name           = "my-alarm"
  comparison_operator  = "GreaterThanThreshold"
  evaluation_periods   = 2
  metric_name          = "CPUUtilization"
  namespace            = "AWS/EC2"
  period               = 300
  threshold            = 80
  alarm_actions        = ["arn:aws:sns:us-east-1:123456789012:example"]
  tags                 = {
    Environment = "dev"
    Project     = "networking"
  }
}
```

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
| [aws_cloudwatch_metric_alarm.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | List of ARNs to notify when the alarm state is triggered | `list(string)` | `[]` | no |
| <a name="input_alarm_description"></a> [alarm\_description](#input\_alarm\_description) | Detailed description of the CloudWatch alarm | `string` | `""` | no |
| <a name="input_alarm_name"></a> [alarm\_name](#input\_alarm\_name) | Name assigned to the CloudWatch alarm | `string` | n/a | yes |
| <a name="input_comparison_operator"></a> [comparison\_operator](#input\_comparison\_operator) | Comparison operator used to evaluate the alarm | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Key-value pairs that define metric dimensions | `map(string)` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Flag to enable or disable creation of the CloudWatch alarm | `bool` | `true` | no |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | Number of periods over which data is compared to the threshold | `number` | `1` | no |
| <a name="input_insufficient_data_actions"></a> [insufficient\_data\_actions](#input\_insufficient\_data\_actions) | List of ARNs to notify when the alarm state is INSUFFICIENT\_DATA | `list(string)` | `[]` | no |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | Name of the CloudWatch metric to monitor | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of the CloudWatch metric | `string` | n/a | yes |
| <a name="input_ok_actions"></a> [ok\_actions](#input\_ok\_actions) | List of ARNs to notify when the alarm state returns to OK | `list(string)` | `[]` | no |
| <a name="input_period"></a> [period](#input\_period) | Evaluation period in seconds (must be a multiple of 60) | `number` | n/a | yes |
| <a name="input_statistic"></a> [statistic](#input\_statistic) | Statistic to apply to the metric (e.g., Average, Sum, Minimum, Maximum) | `string` | `"Average"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the CloudWatch alarm | `map(string)` | `{}` | no |
| <a name="input_threshold"></a> [threshold](#input\_threshold) | Threshold value that triggers the alarm | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_arn"></a> [alarm\_arn](#output\_alarm\_arn) | ARN of the CloudWatch alarm |
| <a name="output_alarm_name"></a> [alarm\_name](#output\_alarm\_name) | Name of the CloudWatch alarm |
<!-- END_TF_DOCS -->
