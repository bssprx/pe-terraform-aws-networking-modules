# cloudwatch_notifications

Creates an SNS topic and optional subscriptions for CloudWatch alarm notifications.

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
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name_prefix](#input_name_prefix) | Prefix for naming resources | `string` | n/a | yes |
| <a name="input_subscribers"></a> [subscribers](#input_subscribers) | List of SNS topic subscribers | <pre>list(object({<br>  protocol = string<br>  endpoint = string<br>}))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Tags to apply to the notification | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_topic_arn"></a> [topic_arn](#output_topic_arn) | ARN of the SNS topic |
<!-- END_TF_DOCS -->
