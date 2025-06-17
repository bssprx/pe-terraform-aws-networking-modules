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

resource "aws_iam_role_policy" "this" {
  name = var.name
  role = var.role

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = var.statements
  })
}