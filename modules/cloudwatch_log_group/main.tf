variable "skip_destroy" {
  description = "Whether to skip log group destruction"
  type        = bool
  default     = false
}

variable "name_prefix" {
  description = "Prefix to use for naming the log group"
  type        = string

  validation {
    condition     = length(trimspace(var.name_prefix)) > 0
    error_message = "name_prefix must not be empty."
  }
}

variable "retention_in_days" {
  description = "How long to retain logs"
  type        = number
  default     = 30

  validation {
    condition     = var.retention_in_days >= 1 && var.retention_in_days <= 3650
    error_message = "retention_in_days must be between 1 and 3650 (inclusive)."
  }
}

variable "kms_key_id" {
  description = "Optional KMS key for encryption"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the log group"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k in ["Environment", "Project"] : contains(keys(var.tags), k)])
    error_message = "The tags map must include 'Environment' and 'Project' keys."
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.name_prefix}-log"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_id
  skip_destroy      = var.skip_destroy
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-log"
  })

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      retention_in_days,
      kms_key_id,
      tags
    ]
  }
}

output "arn" {
  description = "ARN of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.this.arn
}