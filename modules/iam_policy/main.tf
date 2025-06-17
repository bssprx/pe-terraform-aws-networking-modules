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

variable "statements" {
  description = "List of policy statements"
  type        = list(map(any))

  validation {
    condition     = alltrue([for s in var.statements : alltrue([for k in ["Effect", "Action", "Resource"] : contains(keys(s), k)])])
    error_message = "Each policy statement must include 'Effect', 'Action', and 'Resource' keys."
  }
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
    Version   = "2012-10-17"
    Statement = var.statements
  })
}