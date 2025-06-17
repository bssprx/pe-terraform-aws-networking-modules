variable "enabled" {
  type        = bool
  default     = true
  description = "Whether to create the CloudWatch alarm"
}



variable "alarm_name" {
  type        = string
  description = "Name of the CloudWatch alarm"
}

variable "alarm_description" {
  type        = string
  default     = ""
  description = "Description of the alarm"
}

variable "tags" {
  description = "Tags to apply to the alarm"
  type        = map(string)
  default     = {}
}

variable "metric_name" {
  type        = string
  description = "Name of the CloudWatch metric to alarm on"
}

variable "namespace" {
  type        = string
  description = "CloudWatch namespace of the metric"
}

variable "statistic" {
  type        = string
  default     = "Average"
  description = "Statistic to apply to the metric"
}

variable "comparison_operator" {
  type        = string
  description = "Comparison operator for the alarm"
  validation {
    condition     = contains(["GreaterThanThreshold", "GreaterThanOrEqualToThreshold", "LessThanThreshold", "LessThanOrEqualToThreshold"], var.comparison_operator)
    error_message = "comparison_operator must be one of: GreaterThanThreshold, GreaterThanOrEqualToThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  }
}

variable "threshold" {
  type        = number
  description = "Threshold value for the alarm"
}

variable "evaluation_periods" {
  type        = number
  default     = 1
  description = "Number of periods over which data is compared to the threshold"
}

variable "period" {
  type        = number
  description = "Period in seconds over which the metric is evaluated"
  validation {
    condition     = var.period % 60 == 0
    error_message = "The period must be a multiple of 60 seconds."
  }
}

variable "alarm_actions" {
  type        = list(string)
  default     = []
  description = "List of ARNs to notify when the alarm state is triggered"
}

variable "dimensions" {
  type        = map(string)
  default     = {}
  description = "Metric dimensions"
}

resource "aws_cloudwatch_metric_alarm" "this" {
  count               = var.enabled ? 1 : 0
  alarm_name          = var.alarm_name
  alarm_description   = var.alarm_description
  metric_name         = var.metric_name
  namespace           = var.namespace
  statistic           = var.statistic
  comparison_operator = var.comparison_operator
  threshold           = var.threshold
  evaluation_periods  = var.evaluation_periods
  period              = var.period
  alarm_actions       = length(var.alarm_actions) > 0 ? var.alarm_actions : null
  dimensions          = var.dimensions
  tags                = var.tags
}

output "alarm_arn" {
  value       = var.enabled ? aws_cloudwatch_metric_alarm.this[0].arn : null
  description = "ARN of the CloudWatch alarm"
}

output "alarm_name" {
  value       = var.enabled ? aws_cloudwatch_metric_alarm.this[0].alarm_name : null
  description = "Name of the CloudWatch alarm"
}