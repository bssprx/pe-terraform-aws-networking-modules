


variable "name_prefix" {
  description = "Prefix to use for naming resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the rule"
  type        = map(string)
  default     = {}
}

variable "event_pattern" {
  description = "CloudWatch event pattern to match"
  type        = any
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/events/${var.name_prefix}-tgw-monitoring"
  retention_in_days = 14
  tags              = var.tags
}

resource "aws_cloudwatch_event_rule" "this" {
  name          = "${var.name_prefix}-event-rule"
  description   = "Triggers based on user-defined event pattern"
  event_pattern = jsonencode(var.event_pattern)
  tags          = var.tags
}

variable "targets" {
  description = "List of CloudWatch event targets"
  type = list(object({
    target_id = string
    arn       = string
  }))
  default = []
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = { for idx, val in var.targets : idx => val }

  rule      = aws_cloudwatch_event_rule.this.name
  target_id = each.value.target_id
  arn       = each.value.arn
}

variable "enable_alarm" {
  description = "Whether to create a metric alarm"
  type        = bool
  default     = false
}


variable "metric_name" {
  description = "The name of the metric to alarm on"
  type        = string
  default     = null
}

variable "metric_namespace" {
  description = "The namespace of the metric"
  type        = string
  default     = null
}

variable "alarm_description" {
  description = "Description of the CloudWatch alarm"
  type        = string
  default     = null
}

variable "alarm_threshold" {
  description = "Threshold value for the alarm"
  type        = number
  default     = 1
}

resource "aws_cloudwatch_metric_alarm" "this" {
  count               = var.enable_alarm ? 1 : 0
  alarm_name          = "${var.name_prefix}-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = var.metric_name
  namespace           = var.metric_namespace
  period              = 300
  statistic           = "Sum"
  threshold           = var.alarm_threshold
  alarm_description   = var.alarm_description
  actions_enabled     = false
  tags                = var.tags
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.this.arn
}

output "alarm_name" {
  value = try(aws_cloudwatch_metric_alarm.this[0].alarm_name, null)
}