

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the notification"
  type        = map(string)
  default     = {}
}

variable "subscribers" {
  description = "List of SNS topic subscribers"
  type = list(object({
    protocol = string
    endpoint = string
  }))
  default = []
}

resource "aws_sns_topic" "this" {
  name = "${var.name_prefix}-notifications"
  tags = var.tags
}

resource "aws_sns_topic_subscription" "this" {
  for_each = { for idx, sub in var.subscribers : idx => sub }

  topic_arn = aws_sns_topic.this.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}

output "topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.this.arn
}