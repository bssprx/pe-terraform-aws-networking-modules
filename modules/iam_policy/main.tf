variable "policy_name" {
  description = "Name of the policy"
  type        = string

  validation {
    condition     = length(trim(var.policy_name, " ")) > 0
    error_message = "Policy name must be a non-empty string."
  }
}

variable "role" {
  description = "IAM role name to attach the policy to"
  type        = string

  validation {
    condition     = length(trim(var.role, " ")) > 0
    error_message = "IAM role name must be a non-empty string."
  }
}

variable "policy_statements" {
  description = "List of policy statements"
  type = list(object({
    effect    = string
    action    = list(string)
    resource  = list(string)
    condition = optional(any)
  }))
}

variable "enabled" {
  description = "Whether to create the IAM policy"
  type        = bool
  default     = true
}

resource "aws_iam_role_policy" "this" {
  count = var.enabled ? 1 : 0

  name = var.policy_name
  role = var.role

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for s in var.policy_statements : merge({
        Effect   = s.effect
        Action   = s.action
        Resource = s.resource
      }, s.condition != null ? { Condition = s.condition } : {})
    ]
  })
}