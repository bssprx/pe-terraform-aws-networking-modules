variable "name" {
  description = "Name of the policy"
  type        = string
}

variable "role" {
  description = "IAM role name to attach the policy to"
  type        = string
}

variable "statements" {
  description = "List of policy statements"
  type        = list(any)
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