variable "name_prefix" {
  description = "Prefix for the IAM role name"
  type        = string
}

variable "service" {
  description = "The AWS service to allow to assume this role (e.g., 'vpc-flow-logs.amazonaws.com')"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the IAM role"
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Name of the inline policy"
  type        = string
}

variable "policy_statements" {
  description = "List of IAM policy statements"
  type        = list(any)
}

resource "aws_iam_role" "this" {
  name = "${var.name_prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = var.service
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

output "arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.this.name
}
