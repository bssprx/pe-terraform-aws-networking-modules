variable "dns_support" {
  description = "Enable or disable DNS support for the TGW attachment (enable|disable)"
  type        = string
  default     = "enable"
}

variable "ipv6_support" {
  description = "Enable or disable IPv6 support for the TGW attachment (enable|disable)"
  type        = string
  default     = "disable"
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for TGW attachment"
  type        = list(string)
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k in ["Environment", "Project"] : contains(keys(var.tags), k)])
    error_message = "The 'tags' map must contain keys for 'Environment' and 'Project'."
  }
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to attach to the Transit Gateway"
  type        = string
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  subnet_ids         = var.subnet_ids
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id
  dns_support        = var.dns_support
  ipv6_support       = var.ipv6_support

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    Name = "${var.name_prefix}-tgw-attachment"
  }, var.tags)
}

output "id" {
  description = "ID of the Transit Gateway VPC Attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.this.id
}

output "state" {
  description = "The current state of the TGW VPC attachment"
  value       = try(one(aws_ec2_transit_gateway_vpc_attachment.this[*].state), null)
}