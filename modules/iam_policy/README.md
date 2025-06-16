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
