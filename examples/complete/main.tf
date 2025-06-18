locals {
  private_subnet_azs = var.availability_zones

  private_subnets_by_az = {
    for az in var.availability_zones :
    az => try([
      for k, v in module.subnet.private_subnet_ids_by_az :
      v if can(regex(".*-${az}$", k))
    ][0], null)
  }

  logging_sg_ingress_rules = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ssh_ingress_cidrs
    },
    {
      description = "Grafana"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = var.grafana_ingress_cidrs
    },
    {
      description = "Syslog TCP"
      from_port   = 514
      to_port     = 514
      protocol    = "tcp"
      cidr_blocks = var.syslog_ingress_cidrs
    },
    {
      description = "Syslog UDP"
      from_port   = 514
      to_port     = 514
      protocol    = "udp"
      cidr_blocks = var.syslog_ingress_cidrs
    },
  ]

  logging_sg_egress_rules = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  common_tags = var.tags
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type to use"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of your existing AWS EC2 Key Pair"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "sample project"
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "assume_role_arn" {
  description = "IAM role ARN to assume for AWS provider authentication"
  type        = string
}

variable "session_name" {
  description = "Session name when assuming the IAM role"
  type        = string
  default     = "terraform-session"
}

variable "owner" {
  description = "The owner tag used in default tagging"
  type        = string
}

variable "alarm_name_prefix" {
  description = "Prefix used in alarm name"
  type        = string
  default     = "bssprx"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)

  validation {
    condition = alltrue([
      for cidr in var.public_subnet_cidrs : cidrcontains(var.vpc_cidr_block, cidr)
    ])
    error_message = "All public_subnet_cidrs must be within the vpc_cidr_block."
  }
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)

  validation {
    condition = alltrue([
      for cidr in var.private_subnet_cidrs : cidrcontains(var.vpc_cidr_block, cidr)
    ])
    error_message = "All private_subnet_cidrs must be within the vpc_cidr_block."
  }
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}


variable "tags" {
  description = "Map of tags to apply to resources. Must include keys 'Environment' and 'Project'."
  type        = map(string)

  validation {
    condition = alltrue([
      for k in ["Environment", "Project"] : contains(keys(var.tags), k)
    ])
    error_message = "The 'tags' map must contain both 'Environment' and 'Project' keys."
  }
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID to attach to"
  type        = string
}
variable "ssh_ingress_cidrs" {
  description = "List of CIDR blocks allowed to SSH"
  type        = list(string)
}

variable "grafana_ingress_cidrs" {
  description = "List of CIDR blocks allowed to access Grafana"
  type        = list(string)
}

variable "syslog_ingress_cidrs" {
  description = "List of CIDR blocks allowed to send syslog traffic"
  type        = list(string)
}

variable "enable_cloudwatch_alarms" {
  description = "Flag to enable or disable CloudWatch alarms"
  type        = bool
}

variable "log_retention_in_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 90
}

variable "alarm_topic_arns" {
  type        = list(string)
  default     = null
  description = "Optional: SNS topic ARNs for CloudWatch alarm notifications (used if enable_cloudwatch_alarms is true)"

  validation {
    condition = (
      var.enable_cloudwatch_alarms == false ||
      (var.alarm_topic_arns != null && length(var.alarm_topic_arns) > 0)
    )
    error_message = "alarm_topic_arns must be set if enable_cloudwatch_alarms is true."
  }
}

variable "subnet_tags" {
  description = "Additional tags to apply to subnet resources"
  type        = map(string)
}

variable "alarm_topic_subscribers" {
  type = list(object({
    protocol = string
    endpoint = string
  }))
  default     = null
  description = "Optional: Alarm topic subscribers (used if enable_cloudwatch_alarms is true)"

  validation {
    condition = (
      var.enable_cloudwatch_alarms == false ||
      (var.alarm_topic_subscribers != null && length(var.alarm_topic_subscribers) > 0)
    )
    error_message = "alarm_topic_subscribers must be set if enable_cloudwatch_alarms is true."
  }
}

# -------------------------------
# VPC Module
# -------------------------------
module "vpc" {
  source         = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  name_prefix    = var.name_prefix
  tags           = local.common_tags

}

# -------------------------------
# Subnet Module
# -------------------------------
module "subnet" {
  source = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/subnet"
  vpc_id = module.vpc.vpc_id
  cidrs = {
    public  = var.public_subnet_cidrs
    private = var.private_subnet_cidrs
  }
  availability_zones = var.availability_zones
  name_prefix        = var.name_prefix
  tags               = local.common_tags

}

# -------------------------------
# NAT Gateway Module
# -------------------------------
module "nat_gateway" {
  source      = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/nat_gateway"
  for_each    = module.subnet.public_subnet_ids_by_az
  name_prefix = "${var.name_prefix}-${each.key}"
  subnet_id   = each.value
  tags        = local.common_tags

}


# -------------------------------
# Internet Gateway Module
# -------------------------------
module "internet_gateway" {
  source      = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/internet_gateway"
  vpc_id      = module.vpc.vpc_id
  name_prefix = var.name_prefix
  tags        = local.common_tags

}

# -------------------------------
# Public Route Table Module
# -------------------------------
module "route_table_public" {
  source                  = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/route_table_public"
  vpc_id                  = module.vpc.vpc_id
  name_prefix             = var.name_prefix
  public_subnet_ids_by_az = module.subnet.public_subnet_ids_by_az
  internet_gateway_id     = module.internet_gateway.id
  tags                    = local.common_tags

}

# -------------------------------
# Private Route Table Module
# -------------------------------
module "route_table_private" {
  source                   = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/route_table_private"
  vpc_id                   = module.vpc.vpc_id
  name_prefix              = var.name_prefix
  private_subnet_ids_by_az = module.subnet.private_subnet_ids_by_az
  nat_gateway_ids_by_az    = { for az, mod in module.nat_gateway : az => mod.nat_gateway_id }
  tags                     = local.common_tags

}

# -------------------------------
# Transit Gateway Attachment Module
# -------------------------------
module "transit_gateway_attachment" {
  source = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/transit_gateway_attachment"
  count  = var.transit_gateway_id != null ? 1 : 0
  subnet_ids = [
    for az in ["us-east-1a", "us-east-1c"] : module.subnet.private_subnet_ids_by_az[az]
    if contains(keys(module.subnet.private_subnet_ids_by_az), az) && module.subnet.private_subnet_ids_by_az[az] != null
  ]
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = module.vpc.vpc_id
  name_prefix        = var.name_prefix
  tags               = local.common_tags
}

module "cloudwatch_log_group_network" {
  source            = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/cloudwatch_log_group"
  name_prefix       = "${var.name_prefix}-network"
  retention_in_days = var.log_retention_in_days
  tags              = local.common_tags
}

# module "flow_logs_role" {
#   source      = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/iam_role"
#   name_prefix = "${var.name_prefix}-flow-logs"
#   tags        = local.common_tags
#   service     = "vpc-flow-logs.amazonaws.com"
#   policy_name = "AllowCloudWatchLogs"
#   policy_statements = [
#     {
#       actions = [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents",
#         "logs:DescribeLogGroups",
#         "logs:DescribeLogStreams"
#       ]
#       resources = ["*"]
#       effect    = "Allow"
#     }
#   ]
# }

# module "flow_logs_policy" {
#   source = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/iam_policy"
#   name   = "AllowCloudWatchLogs"
#   role   = module.flow_logs_role.name
#   statements = [
#     {
#       actions = [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents",
#         "logs:DescribeLogGroups",
#         "logs:DescribeLogStreams"
#       ]
#       resources = ["*"]
#       effect    = "Allow"
#     }
#   ]
# }

# -------------------------------
# Security Group Module
# -------------------------------
module "logging_sg" {
  source = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/security_group"

  name_prefix   = "${var.name_prefix}-logging"
  vpc_id        = module.vpc.vpc_id
  ingress_rules = local.logging_sg_ingress_rules
  egress_rules  = local.logging_sg_egress_rules

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-logging-sg"
  })
}


# -------------------------------
# CloudWatch Monitoring and Alarm Modules
# -------------------------------
module "cloudwatch_monitoring_rule" {
  source      = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/cloudwatch_monitoring_rule"
  count       = var.enable_cloudwatch_alarms ? 1 : 0
  name_prefix = var.name_prefix
  tags        = local.common_tags
  event_pattern = {
    source      = ["aws.ec2"]
    detail-type = ["EC2 Instance State-change Notification"]
  }
}

module "cloudwatch_notifications" {
  source      = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/cloudwatch_notifications"
  count       = var.enable_cloudwatch_alarms ? 1 : 0
  name_prefix = var.name_prefix
  tags        = local.common_tags
  subscribers = var.alarm_topic_subscribers != null ? var.alarm_topic_subscribers : []
}

module "cloudwatch_alarm" {
  source              = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/cloudwatch_alarm"
  count               = var.enable_cloudwatch_alarms ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}-ec2_cpu_utilization_high"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  evaluation_periods  = 1
  statistic           = "Average"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  alarm_description   = "Alarm when CPU exceeds 80%"
  alarm_actions = (
    var.enable_cloudwatch_alarms &&
    var.alarm_topic_arns != null &&
    length(var.alarm_topic_arns) > 0
  ) ? var.alarm_topic_arns : []
  tags       = local.tags
  depends_on = [module.cloudwatch_monitoring_rule, module.cloudwatch_notifications]
}

module "cloudwatch_alarm_nat_errors" {
  source              = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/cloudwatch_alarm"
  count               = var.enable_cloudwatch_alarms ? length(module.nat_gateway) : 0
  alarm_name          = "${var.alarm_name_prefix}-nat_port_alloc_errors"
  metric_name         = "ErrorPortAllocation"
  namespace           = "AWS/NATGateway"
  period              = 300
  evaluation_periods  = 1
  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  alarm_description   = "Alarm when NAT Gateway has port allocation errors"
  alarm_actions = (
    var.enable_cloudwatch_alarms &&
    var.alarm_topic_arns != null &&
    length(var.alarm_topic_arns) > 0
  ) ? var.alarm_topic_arns : []
  dimensions = {
    NatGatewayId = values(module.nat_gateway)[count.index].nat_gateway_id
  }
  tags       = local.tags
  depends_on = [module.nat_gateway]
}

# -------------------------------
# Outputs for subnet ids by AZ
# -------------------------------
output "public_subnet_ids_by_az" {
  value = module.subnet.public_subnet_ids_by_az
}

output "private_subnet_ids_by_az" {
  value = module.subnet.private_subnet_ids_by_az
}

# -------------------------------
# VPC and Subnet Outputs
# -------------------------------
output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs."
  value       = values(module.subnet.public_subnet_ids_by_az)
}

output "private_subnet_ids" {
  description = "List of private subnet IDs."
  value       = values(module.subnet.private_subnet_ids_by_az)
}

# -------------------------------
# Route Table and Security Group Outputs
# -------------------------------
output "public_route_table_id" {
  description = "The ID of the public route table."
  value       = module.route_table_public.id
}

output "logging_sg_id" {
  description = "The ID of the logging security group."
  value       = module.logging_sg.security_group_id
}

# -------------------------------
# Transit Gateway Attachment Output
# -------------------------------
output "tgw_attachment_state" {
  description = "The state of the Transit Gateway VPC attachment."
  value       = module.transit_gateway_attachment[0].state
}


output "tgw_attachment_id" {
  description = "The ID of the Transit Gateway VPC attachment."
  value       = module.transit_gateway_attachment[0].id
}


# -------------------------------
# VPC Flow Logs
# -------------------------------

# Replaces the inline aws_flow_log.vpc resource with a module
# module "vpc_flow_log" {
#   source        = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/flow_log"
#   vpc_id        = module.vpc.vpc_id
#   log_group_arn = module.cloudwatch_log_group_network.arn
#   iam_role_arn  = module.flow_logs_role.arn
#   tags          = local.common_tags
# }
