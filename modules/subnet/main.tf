variable "vpc_id" {
  description = "The ID of the VPC to create the subnets in"
  type        = string
}

variable "cidrs" {
  description = "List of CIDR blocks for the subnets"
  type = object({
    public  = list(string)
    private = list(string)
  })
}

variable "availability_zones" {
  description = "List of availability zones for the subnets"
  type        = list(string)
}

variable "map_public_ip_on_launch" {
  description = "Whether to enable auto-assign public IP on launch"
  type        = bool
  default     = false
}

variable "name_prefix" {
  description = "Prefix for subnet names"
  type        = string
}

variable "tags" {
  description = "Map of tags to assign to the subnets"
  type        = map(string)
  default     = {}
}

resource "aws_subnet" "this" {
  for_each = {
    for pair in flatten([
      for subnet_type, cidr_list in var.cidrs :
      [
        for idx, cidr in cidr_list : {
          key               = "${subnet_type}-${idx}"
          cidr_block        = cidr
          availability_zone = var.availability_zones[idx]
          type              = subnet_type
          index             = idx
        }
      ]
    ]) : pair.key => pair
  }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-${each.value.type}-${each.value.availability_zone}"
  })
}

output "subnet_ids" {
  description = "List of subnet IDs created"
  value       = [for s in aws_subnet.this : s.id]
}

output "availability_zones" {
  description = "Availability zones used for the subnets"
  value       = var.availability_zones
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = [
    for s in aws_subnet.this :
    s.id if can(regex("${var.name_prefix}-public-[a-z]+-[0-9]+", s.tags["Name"]))
  ]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value = [
    for s in aws_subnet.this :
    s.id if can(regex("${var.name_prefix}-private-[a-z]+-[0-9]+", s.tags["Name"]))
  ]
}

output "vpc_id" {
  description = "The VPC ID these subnets belong to"
  value       = var.vpc_id
}

output "public_subnet_ids_by_az" {
  description = "Map of public subnet IDs by AZ"
  value = {
    for s in aws_subnet.this :
    s.availability_zone => s.id
    if can(regex("${var.name_prefix}-public-${s.availability_zone}", s.tags["Name"]))
  }
}

output "private_subnet_ids_by_az" {
  description = "Map of private subnet IDs by AZ"
  value = {
    for s in aws_subnet.this :
    s.availability_zone => s.id
    if can(regex("${var.name_prefix}-private-${s.availability_zone}", s.tags["Name"]))
  }
}