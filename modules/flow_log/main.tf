variable "traffic_type" {
  description = "Type of traffic to log. Valid values: ACCEPT, REJECT, or ALL."
  type        = string
  default     = "REJECT"
}
variable "vpc_id" {
  description = "ID of the VPC to enable flow logs for"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Optional: ID of the subnet to enable flow logs for"
  type        = string
  default     = null
}

variable "eni_id" {
  description = "Optional: ID of the network interface to enable flow logs for"
  type        = string
  default     = null
}

variable "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  type        = string
}

variable "iam_role_arn" {
  description = "IAM role ARN to use for delivering flow logs"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the flow log"
  type        = map(string)
  default     = {}
}

variable "target_resource" {
  description = "The resource ID to enable flow logs for (vpc_id, subnet_id, or eni_id)"
  type        = string
  default     = null
}

locals {
  targets_set = [
    var.vpc_id != null,
    var.subnet_id != null,
    var.eni_id != null,
  ]
}

resource "aws_flow_log" "this" {
  log_destination      = var.log_group_arn
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = var.iam_role_arn
  traffic_type         = var.traffic_type
  tags                 = var.tags

  vpc_id    = var.vpc_id != null ? var.vpc_id : null
  subnet_id = var.subnet_id != null ? var.subnet_id : null
  eni_id    = var.eni_id != null ? var.eni_id : null

  lifecycle {
    precondition {
      condition     = length([for v in [var.vpc_id, var.subnet_id, var.eni_id] : v if v != null]) == 1
      error_message = "Exactly one of vpc_id, subnet_id, or eni_id must be set."
    }
  }
}

output "id" {
  description = "The ID of the flow log"
  value       = aws_flow_log.this.id
}

output "arn" {
  description = "The ARN of the flow log"
  value       = aws_flow_log.this.arn
}
