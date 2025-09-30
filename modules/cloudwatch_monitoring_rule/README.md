# cloudwatch_monitoring_rule

This module creates a CloudWatch event rule, optional metric alarm, log group, and associated targets for AWS infrastructure monitoring.

## Usage

```hcl
module "cloudwatch_monitoring_rule" {
  source = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/cloudwatch_monitoring_rule?ref=v0.2.0"

  name_prefix       = "example"
  event_pattern     = jsondecode(file("${path.module}/event-pattern.json"))
  targets           = [{ target_id = "lambda", arn = "arn:aws:lambda:region:acct-id:function:name" }]
  enable_alarm      = true
  alarm_threshold   = 1
  metric_name       = "Errors"
  metric_namespace  = "AWS/Lambda"
  alarm_description = "Monitor Lambda function errors"

  tags = {
    Environment = "dev"
    Project     = "example"
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
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_description"></a> [alarm\_description](#input\_alarm\_description) | Description of the CloudWatch alarm | `string` | `null` | no |
| <a name="input_alarm_threshold"></a> [alarm\_threshold](#input\_alarm\_threshold) | Threshold value for the alarm | `number` | `1` | no |
| <a name="input_enable_alarm"></a> [enable\_alarm](#input\_enable\_alarm) | Whether to create a metric alarm | `bool` | `false` | no |
| <a name="input_event_pattern"></a> [event\_pattern](#input\_event\_pattern) | CloudWatch event pattern to match | `any` | n/a | yes |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | The name of the metric to alarm on | `string` | `null` | no |
| <a name="input_metric_namespace"></a> [metric\_namespace](#input\_metric\_namespace) | The namespace of the metric | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix to use for naming resources | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Number of days to retain log events | `number` | `14` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the rule | `map(string)` | `{}` | no |
| <a name="input_targets"></a> [targets](#input\_targets) | List of CloudWatch event targets | ```list(object({ target_id = string arn = string role_arn = optional(string) }))``` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_name"></a> [alarm\_name](#output\_alarm\_name) | n/a |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | n/a |
<!-- END_TF_DOCS -->