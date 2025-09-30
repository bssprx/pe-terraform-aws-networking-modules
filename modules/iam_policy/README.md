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
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the policy | `string` | n/a | yes |
| <a name="input_role"></a> [role](#input\_role) | IAM role name to attach the policy to | `string` | n/a | yes |
| <a name="input_statements"></a> [statements](#input\_statements) | List of policy statements | `list(any)` | n/a | yes |

## Outputs

No outputs.

# IAM Policy Module

This module creates and attaches an IAM policy to the specified IAM role.

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether to create the IAM policy | `bool` | `true` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Name of the policy | `string` | n/a | yes |
| <a name="input_policy_statements"></a> [policy\_statements](#input\_policy\_statements) | List of policy statements | ```list(object({ effect = string action = list(string) resource = list(string) condition = optional(any) }))``` | n/a | yes |
| <a name="input_role"></a> [role](#input\_role) | IAM role name to attach the policy to | `string` | n/a | yes |
<!-- END_TF_DOCS -->