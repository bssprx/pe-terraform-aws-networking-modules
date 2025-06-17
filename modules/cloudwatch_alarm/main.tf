variable "alarm_actions" {
  type        = list(string)
  default     = []
  description = "List of ARNs to notify when the alarm state is triggered"
}

variable "alarm_description" {
  type        = string
  default     = ""
  description = "Detailed description of the CloudWatch alarm"
}

variable "alarm_name" {
  type        = string
  description = "Name assigned to the CloudWatch alarm"
}

variable "comparison_operator" {
  type        = string
  description = "Comparison operator used to evaluate the alarm"
  validation {
    condition     = contains(["GreaterThanThreshold", "GreaterThanOrEqualToThreshold", "LessThanThreshold", "LessThanOrEqualToThreshold"], var.comparison_operator)
    error_message = "comparison_operator must be one of: GreaterThanThreshold, GreaterThanOrEqualToThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  }
}

variable "dimensions" {
  type        = map(string)
  default     = {}
  description = "Key-value pairs that define metric dimensions"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Flag to enable or disable creation of the CloudWatch alarm"
}

variable "evaluation_periods" {
  type        = number
  default     = 1
  description = "Number of periods over which data is compared to the threshold"
}

variable "insufficient_data_actions" {
  type        = list(string)
  default     = []
  description = "List of ARNs to notify when the alarm state is INSUFFICIENT_DATA"
}

variable "metric_name" {
  type        = string
  description = "Name of the CloudWatch metric to monitor"
}

variable "namespace" {
  type        = string
  description = "Namespace of the CloudWatch metric"
}

variable "ok_actions" {
  type        = list(string)
  default     = []
  description = "List of ARNs to notify when the alarm state returns to OK"
}

variable "period" {
  type        = number
  description = "Evaluation period in seconds (must be a multiple of 60)"
  validation {
    condition     = var.period % 60 == 0
    error_message = "The period must be a multiple of 60 seconds."
  }
}

variable "statistic" {
  type        = string
  default     = "Average"
  description = "Statistic to apply to the metric (e.g., Average, Sum, Minimum, Maximum)"
}

variable "tags" {
  description = "Tags to assign to the CloudWatch alarm"
  type        = map(string)
  default     = {}
  validation {
    condition     = alltrue([for k in ["Environment", "Project"] : contains(keys(var.tags), k)])
    error_message = "The 'tags' map must include 'Environment' and 'Project' keys."
  }
}

variable "threshold" {
  type        = number
  description = "Threshold value that triggers the alarm"
}

resource "aws_cloudwatch_metric_alarm" "this" {
  count                     = var.enabled ? 1 : 0
  alarm_name                = var.alarm_name
  alarm_description         = var.alarm_description
  metric_name               = var.metric_name
  namespace                 = var.namespace
  statistic                 = var.statistic
  comparison_operator       = var.comparison_operator
  threshold                 = var.threshold
  evaluation_periods        = var.evaluation_periods
  period                    = var.period
  alarm_actions             = length(var.alarm_actions) > 0 ? var.alarm_actions : null
  ok_actions                = length(var.ok_actions) > 0 ? var.ok_actions : null
  insufficient_data_actions = length(var.insufficient_data_actions) > 0 ? var.insufficient_data_actions : null
  dimensions                = var.dimensions
  tags                      = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

output "alarm_arn" {
  value       = var.enabled ? aws_cloudwatch_metric_alarm.this[0].arn : null
  description = "ARN of the CloudWatch alarm"
}

output "alarm_name" {
  value       = var.enabled ? aws_cloudwatch_metric_alarm.this[0].alarm_name : null
  description = "Name of the CloudWatch alarm"
}