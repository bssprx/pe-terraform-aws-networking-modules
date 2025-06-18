# cloudwatch_notifications

Creates an SNS topic and optional subscriptions for CloudWatch alarm notifications.

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
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for naming resources | `string` | n/a | yes |
| <a name="input_subscribers"></a> [subscribers](#input\_subscribers) | List of SNS topic subscribers | <pre>list(object({<br/>    protocol = string<br/>    endpoint = string<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the notification. Must include 'Environment' and 'Project'. | `map(string)` | `{}` | no |
| <a name="input_topic_display_name"></a> [topic\_display\_name](#input\_topic\_display\_name) | Optional display name for the SNS topic | `string` | `null` | no |
| <a name="input_topic_policy"></a> [topic\_policy](#input\_topic\_policy) | Optional JSON policy for the SNS topic | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_topic_arn"></a> [topic\_arn](#output\_topic\_arn) | ARN of the SNS topic |
<!-- END_TF_DOCS -->
