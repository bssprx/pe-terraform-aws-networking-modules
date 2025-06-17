variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "name_prefix" {
  description = "Prefix to use for VPC naming"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to the VPC"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      contains(keys(var.tags), "Environment"),
      contains(keys(var.tags), "Project"),
    ])
    error_message = "The tags map must include keys 'Environment' and 'Project'."
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = length(var.vpc_cidr_block) > 0
    error_message = "The vpc_cidr_block variable must not be empty."
  }
}

variable "vpc_name" {
  description = "Optional name to override the default VPC name"
  type        = string
  default     = null
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.tags,
    {
      Name = var.vpc_name != null ? var.vpc_name : "${var.name_prefix}-vpc"
    }
  )

  lifecycle {
    prevent_destroy = true
  }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}