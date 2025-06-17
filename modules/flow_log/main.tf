# -----------------------
# Variables
# -----------------------
variable "enabled" {
  description = "Whether to enable the flow log resources."
  type        = bool
  default     = true
}

variable "eni_id" {
  description = "The ID of the network interface to enable flow logs for."
  type        = string
  default     = null
}

variable "iam_role_arn" {
  description = "The IAM role ARN to use for delivering flow logs."
  type        = string
  validation {
    condition     = can(regex("^arn:aws:iam::", var.iam_role_arn))
    error_message = "iam_role_arn must start with 'arn:aws:iam::'."
  }
}

variable "log_group_arn" {
  description = "The ARN of the CloudWatch log group. If not provided, a log group will be created."
  type        = string
  default     = null
  validation {
    condition     = var.log_group_arn == null || can(regex("^arn:aws:logs:", var.log_group_arn))
    error_message = "log_group_arn must start with 'arn:aws:logs:' if provided."
  }
}

variable "log_group_name_prefix" {
  description = "The prefix for the CloudWatch log group name if created."
  type        = string
  default     = "vpc-flow-"
}

variable "retention_in_days" {
  description = "The number of days to retain log events in the CloudWatch log group."
  type        = number
  default     = null
  validation {
    condition     = var.retention_in_days == null || contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.retention_in_days)
    error_message = "Retention must be one of the allowed values per AWS documentation, or null to use default."
  }
}

variable "subnet_id" {
  description = "The ID of the subnet to enable flow logs for."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the flow log. Must include 'Environment' and 'Project'."
  type        = map(string)
  default     = {}
  validation {
    condition     = alltrue([for k in ["Environment", "Project"] : contains(keys(var.tags), k)])
    error_message = "The 'tags' map must include both 'Environment' and 'Project' keys."
  }
}

variable "target_resource" {
  description = "The resource ID to enable flow logs for (vpc_id, subnet_id, or eni_id)."
  type        = string
  default     = null
}

variable "traffic_type" {
  description = "The type of traffic to log. Valid values: ACCEPT, REJECT, or ALL."
  type        = string
  default     = "REJECT"
}

variable "vpc_id" {
  description = "The ID of the VPC to enable flow logs for."
  type        = string
  default     = null
}

# -----------------------
# Locals
# -----------------------
locals {
  targets_set = [
    var.vpc_id != null,
    var.subnet_id != null,
    var.eni_id != null,
  ]
}

# -----------------------
# Resources
# -----------------------
resource "aws_cloudwatch_log_group" "this" {
  count             = var.enabled && var.log_group_arn == null ? 1 : 0
  name_prefix       = var.log_group_name_prefix
  retention_in_days = var.retention_in_days != null ? var.retention_in_days : 30
  tags              = var.tags
}

resource "aws_flow_log" "this" {
  count                = var.enabled ? 1 : 0
  log_destination      = var.log_group_arn != null ? var.log_group_arn : aws_cloudwatch_log_group.this[0].arn
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = var.iam_role_arn
  traffic_type         = var.traffic_type
  tags                 = var.tags

  vpc_id    = var.vpc_id != null ? var.vpc_id : null
  subnet_id = var.subnet_id != null ? var.subnet_id : null
  eni_id    = var.eni_id != null ? var.eni_id : null

  depends_on = [
    aws_cloudwatch_log_group.this
  ]

  lifecycle {
    precondition {
      condition     = length([for v in [var.vpc_id, var.subnet_id, var.eni_id] : v if v != null]) == 1
      error_message = "Exactly one of vpc_id, subnet_id, or eni_id must be set."
    }
  }
}

# -----------------------
# Outputs
# -----------------------
output "id" {
  description = "The ID of the flow log"
  value       = var.enabled ? aws_flow_log.this[0].id : null
}

output "arn" {
  description = "The ARN of the flow log"
  value       = var.enabled ? aws_flow_log.this[0].arn : null
}

output "log_group_name" {
  description = "Name of the CloudWatch log group used by the flow log"
  value       = var.enabled && var.log_group_arn == null ? aws_cloudwatch_log_group.this[0].name : null
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group used by the flow log"
  value       = var.enabled ? (var.log_group_arn != null ? var.log_group_arn : aws_cloudwatch_log_group.this[0].arn) : null
}