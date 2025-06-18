variable "name" {
  description = "Name of the policy"
  type        = string

  validation {
    condition     = length(trim(var.name, " ")) > 0
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

variable "policy_statement" {
  description = "List of policy statements"
  type = list(object({
    effect   = string
    actions  = list(string)
    resource = list(string)
  }))
}

variable "enabled" {
  description = "Whether to create the IAM policy"
  type        = bool
  default     = true
}

resource "aws_iam_role_policy" "this" {
  count = var.enabled ? 1 : 0

  name = var.name
  role = var.role

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for s in var.policy_statement : {
        Effect   = s.effect
        Action   = s.actions
        Resource = s.resource
      }
    ]
  })
}