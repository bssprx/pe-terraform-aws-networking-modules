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

  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project
  })
}



variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID to attach to"
  type        = string
}
variable "ssh_ingress_cidrs" {
  description = "List of CIDR blocks allowed to SSH"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "grafana_ingress_cidrs" {
  description = "List of CIDR blocks allowed to access Grafana"
  type        = list(string)
  default     = []
}

variable "syslog_ingress_cidrs" {
  description = "List of CIDR blocks allowed to send syslog traffic"
  type        = list(string)
  default     = []
}

variable "enable_cloudwatch_alarms" {
  description = "Flag to enable or disable CloudWatch alarms"
  type        = bool
  default     = false
}

variable "alarm_topic_arns" {
  description = "List of SNS topic ARNs to notify when CloudWatch alarms are triggered"
  type        = list(string)
  default     = []
}

variable "subnet_tags" {
  description = "Additional tags to apply to subnet resources"
  type        = map(string)
  default     = {}
}

variable "alarm_topic_subscribers" {
  description = "List of subscriber objects for CloudWatch alarm notifications"
  type = list(object({
    protocol = string
    endpoint = string
  }))
  default = []
}

# -------------------------------
# VPC Module
# -------------------------------
module "vpc" {
  source       = "../vpc"
  vpc_cidr_block = var.vpc_cidr_block
  name_prefix  = var.name_prefix
  tags         = local.common_tags
}

# -------------------------------
# Subnet Module
# -------------------------------
module "subnet" {
  source                = "../subnet"
  vpc_id                = module.vpc.vpc_id
  cidrs                 = {
    public = var.public_subnet_cidrs
    private  = var.private_subnet_cidrs
  }
  availability_zones    = var.availability_zones
  name_prefix           = var.name_prefix
  tags                  = local.common_tags
}

# -------------------------------
# NAT Gateway Module
# -------------------------------
module "nat_gateway" {
  source      = "../nat_gateway"
  for_each    = module.subnet.public_subnet_ids_by_az
  name_prefix = "${var.name_prefix}-${each.key}"
  subnet_id   = each.value
  tags        = local.common_tags
}


# -------------------------------
# Internet Gateway Module
# -------------------------------
module "internet_gateway" {
  source      = "../internet_gateway"
  vpc_id      = module.vpc.vpc_id
  name_prefix = var.name_prefix
  tags        = local.common_tags
}

# -------------------------------
# Public Route Table Module
# -------------------------------
module "route_table_public" {
  source                   = "../route_table_public"
  vpc_id                   = module.vpc.vpc_id
  name_prefix              = var.name_prefix
  public_subnet_ids_by_az  = module.subnet.public_subnet_ids_by_az
  internet_gateway_id      = module.internet_gateway.id
  tags                     = local.common_tags
}

# -------------------------------
# Private Route Table Module
# -------------------------------
module "route_table_private" {
  source                   = "../route_table_private"
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
  source                         = "../transit_gateway_attachment"
  count                          = var.transit_gateway_id != null ? 1 : 0
  subnet_ids                     = [
    for az in ["us-east-1a", "us-east-1c"] : module.subnet.private_subnet_ids_by_az[az]
    if contains(keys(module.subnet.private_subnet_ids_by_az), az) && module.subnet.private_subnet_ids_by_az[az] != null
  ]
  transit_gateway_id             = var.transit_gateway_id
  vpc_id                         = module.vpc.vpc_id
  name_prefix                    = var.name_prefix
  tags                           = local.common_tags
}

module "cloudwatch_log_group_network" {
  source           = "../cloudwatch_log_group"
  name_prefix      = "${var.name_prefix}-network"
  retention_in_days = 90
}

module "flow_logs_role" {
  source       = "../iam_role"
  name_prefix  = "${var.name_prefix}-flow-logs"
  tags         = local.common_tags
  service      = "vpc-flow-logs.amazonaws.com"
  policy_name  = "AllowCloudWatchLogs"
  policy_statements = [
    {
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "*"
    }
  ]
}

module "flow_logs_policy" {
  source     = "../iam_policy"
  name       = "AllowCloudWatchLogs"
  role       = module.flow_logs_role.name
  statements = [
    {
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "*"
    }
  ]
}

# -------------------------------
# Security Group Module
# -------------------------------
module "logging_sg" {
  source = "../security_group"

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
  source                = "../cloudwatch_monitoring_rule"
  name_prefix           = var.name_prefix
  tags                  = local.common_tags
  event_pattern = {
    source      = ["aws.ec2"]
    detail-type = ["EC2 Instance State-change Notification"]
  }
}

module "cloudwatch_notifications" {
  source       = "../cloudwatch_notifications"
  name_prefix  = var.name_prefix
  tags         = local.common_tags
  subscribers  = var.alarm_topic_subscribers
}

module "cloudwatch_alarm" {
  source                = "../cloudwatch_alarm"
  alarm_name            = "${var.name_prefix}-ec2_cpu_utilization_high"
  metric_name           = "CPUUtilization"
  namespace             = "AWS/EC2"
  period                = 300
  evaluation_periods    = 1
  statistic             = "Average"
  comparison_operator   = "GreaterThanThreshold"
  threshold             = 80
  alarm_description     = "Alarm when CPU exceeds 80%"
  alarm_actions         = [module.cloudwatch_notifications.topic_arn]
}

# -------------------------------
# CloudWatch Alarm for NAT Gateway Port Allocation Errors
# -------------------------------
module "cloudwatch_alarm_nat_errors" {
  source                = "../cloudwatch_alarm"
  for_each              = module.nat_gateway
  alarm_name            = "${var.name_prefix}-nat_port_alloc_errors"
  metric_name           = "ErrorPortAllocation"
  namespace             = "AWS/NATGateway"
  period                = 300
  evaluation_periods    = 1
  statistic             = "Sum"
  comparison_operator   = "GreaterThanThreshold"
  threshold             = 0
  alarm_description     = "Alarm when NAT Gateway has port allocation errors"
  alarm_actions         = [module.cloudwatch_notifications.topic_arn]
  dimensions = {
    NatGatewayId = each.value.nat_gateway_id
  }
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
  value       = module.subnet.vpc_id
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
module "vpc_flow_log" {
  source        = "../flow_log"
  vpc_id        = module.vpc.vpc_id
  log_group_arn = module.cloudwatch_log_group_network.arn
  iam_role_arn  = module.flow_logs_role.arn
  tags          = local.common_tags
}