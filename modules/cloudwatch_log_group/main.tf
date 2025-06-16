variable "name_prefix" {
  description = "Prefix to use for naming the log group"
  type        = string
}

variable "retention_in_days" {
  description = "How long to retain logs"
  type        = number
  default     = 30
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
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.name_prefix}-log"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_id
  tags              = merge(var.tags, {
    Name = "${var.name_prefix}-log"
  })
}

output "arn" {
  description = "ARN of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.this.arn
}