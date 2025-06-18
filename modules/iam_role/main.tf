variable "name_prefix" {
  description = "Prefix for the IAM role name"
  type        = string
}

variable "service" {
  description = "The AWS service to allow to assume this role (e.g., 'vpc-flow-logs.amazonaws.com')"
  type        = string
  validation {
    condition     = length(trim(var.service, " ")) > 0
    error_message = "The service name must not be empty."
  }
}

variable "tags" {
  description = "Tags to apply to the IAM role"
  type        = map(string)
  default     = {}
  validation {
    condition     = alltrue([for k in ["Environment", "Project"] : contains(keys(var.tags), k)])
    error_message = "The tags map must include keys 'Environment' and 'Project'."
  }
}

variable "policy_name" {
  description = "Name of the inline policy"
  type        = string
}

variable "policy_statement" {
  description = "List of IAM policy statements"
  type = list(object({
    effect    = string
    action    = list(string)
    resource  = list(string)
    condition = optional(map(any))
  }))
  validation {
    condition     = length(var.policy_statement) > 0
    error_message = "At least one policy statement must be provided."
  }
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

  # Prevent Terraform from triggering updates if only tags are changed outside Terraform
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_iam_role_policy" "this" {
  name = var.policy_name
  role = aws_iam_role.this.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for s in var.policy_statement : {
        Effect    = s.effect
        Action    = s.action
        Resource  = s.resource
        Condition = lookup(s, "condition", null)
      }
    ]
  })
}

output "arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.this.name
}

output "policy_name" {
  description = "Name of the IAM policy"
  value       = aws_iam_role_policy.this.name
}
